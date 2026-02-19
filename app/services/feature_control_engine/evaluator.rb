module FeatureControlEngine
  class Evaluator
    def initialize(feature: nil, user: nil, region: nil, override_index: nil, default_state: nil)
      @feature = feature
      @user = user
      @group_id = user&.group_id
      @region = region
      @override_index = override_index
      @default_state = default_state
    end

    def call
      if @user
        user_state = find_override_state("user", @user.id)
        return user_state unless user_state.nil?
      end

      if @group_id
        group_state = find_override_state("group", @group_id)
        return group_state unless group_state.nil?
      end
      if @region
        region_state = find_override_state("region", @region)
        return region_state unless region_state.nil?
      end

      return @default_state unless @default_state.nil?
      @feature.default_state
    end

    private

    # Build an in-memory index once to keep evaluation O(1) per lookup.
    def override_index
      @override_index ||= @feature.feature_overrides.each_with_object({}) do |override, index|
        index[[ override.override_type, override.override_id.to_s ]] = override.state
      end
    end

    def find_override_state(type, id)
      override_index[[ type, id.to_s ]]
    end
  end
end
