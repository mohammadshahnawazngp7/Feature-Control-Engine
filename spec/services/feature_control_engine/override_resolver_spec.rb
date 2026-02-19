require "rails_helper"

RSpec.describe FeatureControlEngine::OverrideResolver, type: :service do
  let!(:group) { Group.create!(name: "Beta") }
  let!(:user) { User.create!(name: "John", group: group) }
  let!(:feature) { Feature.create!(name: "dark_mode", default_state: false) }

  it "finds a matching override" do
    override = FeatureOverride.create!(
      feature: feature,
      override_type: "user",
      override_id: user.id,
      state: true
    )

    resolver = described_class.new(feature)
    result = resolver.find(type: "user", id: user.id)

    expect(result).to eq(override)
  end

  it "returns nil when no override exists" do
    resolver = described_class.new(feature)
    result = resolver.find(type: "group", id: group.id)

    expect(result).to be_nil
  end
end
