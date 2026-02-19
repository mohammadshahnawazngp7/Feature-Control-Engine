require 'rails_helper'

RSpec.describe "Feature Evaluation API", type: :request do
  let!(:group) { Group.create!(name: "Beta") }
  let!(:user) { User.create!(name: "John", group: group) }
  let!(:feature) { Feature.create!(name: "dark_mode", default_state: false) }

  it "returns enabled for user override" do
    FeatureOverride.create!(
      feature: feature,
      override_type: "user",
      override_id: user.id,
      state: true
    )

    get "/api/v1/features/#{feature.id}/evaluate", params: { user_id: user.id }

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json["enabled"]).to eq(true)
  end

  it "returns region override when no user or group override exists" do
    FeatureOverride.create!(
      feature: feature,
      override_type: "region",
      override_id: "us-east",
      state: true
    )

    get "/api/v1/features/#{feature.id}/evaluate", params: { region: "us-east" }

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json["enabled"]).to eq(true)
  end

  it "returns default when overrides are missing" do
    get "/api/v1/features/#{feature.id}/evaluate"

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json["enabled"]).to eq(false)
  end

  it "returns 404 when user does not exist" do
    get "/api/v1/features/#{feature.id}/evaluate", params: { user_id: 999999 }

    expect(response).to have_http_status(:not_found)
  end
end
