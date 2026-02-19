module FeatureControlEngine
  class OverrideResolver
    def initialize(feature)
      @feature = feature
    end

    # In-memory search
    def find(type:, id:)
      @feature.feature_overrides.detect do |o|
        o.override_type == type &&
        o.override_id.to_s == id.to_s
      end
    end
  end
end
