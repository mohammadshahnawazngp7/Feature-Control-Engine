# app/services/feature_control_engine/cache_store.rb
module FeatureControlEngine
  class CacheStore
    CACHE_NAMESPACE = "feature_control_engine:eval"

    def self.fetch(feature_id)
      Rails.cache.fetch(cache_key(feature_id)) { build_payload(feature_id) }
    end

    def self.invalidate(feature_id)
      Rails.cache.delete(cache_key(feature_id))
    end

    def self.cache_key(feature_id)
      "#{CACHE_NAMESPACE}:#{feature_id}"
    end

    def self.build_payload(feature_id)
      feature = Feature.includes(:feature_overrides).find(feature_id)
      {
        name: feature.name,
        default_state: feature.default_state,
        overrides: feature.feature_overrides.each_with_object({}) do |override, index|
          index[[ override.override_type, override.override_id.to_s ]] = override.state
        end
      }
    end

    private_class_method :cache_key, :build_payload
  end
end
