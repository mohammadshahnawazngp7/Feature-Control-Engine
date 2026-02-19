# spec/models/feature_override_spec.rb
require 'rails_helper'

RSpec.describe FeatureOverride, type: :model do
  let!(:feature) { Feature.create!(name: "dark_mode", default_state: false) }
  let!(:user) { Group.create!(name: "Beta").users.create!(name: "John") }

  it "is valid with valid attributes" do
    override = FeatureOverride.new(feature: feature, override_type: "user", override_id: user.id, state: true)
    expect(override).to be_valid
  end

  it "is invalid without override_type" do
    override = FeatureOverride.new(feature: feature, override_id: user.id, state: true)
    expect(override).to_not be_valid
  end

  it "prevents duplicate override" do
    FeatureOverride.create!(feature: feature, override_type: "user", override_id: user.id, state: true)
    dup_override = FeatureOverride.new(feature: feature, override_type: "user", override_id: user.id, state: false)
    expect(dup_override).to_not be_valid
  end

  it "allows region override type" do
    override = FeatureOverride.new(
      feature: feature,
      override_type: "region",
      override_id: "us-east",
      state: true
    )
    expect(override).to be_valid
  end
end
