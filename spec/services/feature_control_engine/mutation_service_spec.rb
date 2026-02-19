# spec/services/feature_control_engine/mutation_service_spec.rb
require 'rails_helper'

RSpec.describe FeatureControlEngine::MutationService, type: :service do
  let!(:feature) { Feature.create!(name: "dark_mode", default_state: false) }
  let!(:group) { Group.create!(name: "Beta") }
  let!(:user) { User.create!(name: "John", group: group) }

  it "creates a feature" do
    f = described_class.create_feature(name: "new_dashboard", default_state: true)
    expect(f).to be_persisted
  end

  it "updates a feature" do
    described_class.update_feature(feature, default_state: true)
    expect(feature.reload.default_state).to eq(true)
  end

  it "creates an override" do
    o = described_class.create_override(
      feature,
      override_type: "user",
      override_id: user.id,
      state: true
    )
    expect(o).to be_persisted
  end

  it "updates an override" do
    o = FeatureOverride.create!(feature: feature, override_type: "user", override_id: user.id, state: false)
    described_class.update_override(o, state: true)
    expect(o.reload.state).to eq(true)
  end
end
