require "rails_helper"

RSpec.describe FeatureControlEngine::Evaluator, type: :service do
  let!(:group) { Group.create!(name: "Beta") }
  let!(:user) { User.create!(name: "John", group: group) }
  let!(:feature) { Feature.create!(name: "dark_mode", default_state: false) }

  it "returns user override when present" do
    FeatureOverride.create!(
      feature: feature,
      override_type: "user",
      override_id: user.id,
      state: true
    )

    result = described_class.new(feature: feature, user: user).call
    expect(result).to eq(true)
  end

  it "returns group override when user override is absent" do
    FeatureOverride.create!(
      feature: feature,
      override_type: "group",
      override_id: group.id,
      state: true
    )

    result = described_class.new(feature: feature, user: user).call
    expect(result).to eq(true)
  end

  it "returns default when no overrides exist" do
    result = described_class.new(feature: feature, user: user).call
    expect(result).to eq(false)
  end

  it "returns default when no user is provided" do
    FeatureOverride.create!(
      feature: feature,
      override_type: "user",
      override_id: user.id,
      state: true
    )

    result = described_class.new(feature: feature).call
    expect(result).to eq(false)
  end

  it "returns region override when provided and no user/group override exists" do
    FeatureOverride.create!(
      feature: feature,
      override_type: "region",
      override_id: "us-east",
      state: true
    )

    result = described_class.new(feature: feature.reload, region: "us-east").call
    expect(result).to eq(true)
  end

  it "prioritizes user/group over region" do
    FeatureOverride.create!(
      feature: feature,
      override_type: "region",
      override_id: "us-east",
      state: true
    )
    FeatureOverride.create!(
      feature: feature,
      override_type: "group",
      override_id: group.id,
      state: false
    )

    result = described_class.new(feature: feature, user: user, region: "us-east").call
    expect(result).to eq(false)
  end
end
