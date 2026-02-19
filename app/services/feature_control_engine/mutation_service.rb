# app/services/feature_control_engine/mutation_service.rb
module FeatureControlEngine
  class MutationService
    def self.create_feature(params)
      Feature.create!(params)
    end

    def self.update_feature(feature, params)
      feature.update!(params)
      feature
    end

    def self.create_override(feature, params)
      feature.feature_overrides.create!(params)
    end

    def self.update_override(override, params)
      override.update!(params)
      override
    end
  end
end
