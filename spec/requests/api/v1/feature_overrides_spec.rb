require 'rails_helper'

RSpec.describe "FeatureOverrides API", type: :request do
  let!(:group) { Group.create!(name: "Beta") }
  let!(:user) { User.create!(name: "John", group: group) }
  let!(:feature) { Feature.create!(name: "dark_mode", default_state: false) }

  describe "POST /api/v1/features/:feature_id/overrides" do
    it "creates a user override" do
      post "/api/v1/features/#{feature.id}/overrides", params: {
        feature_override: {
          override_type: "user",
          override_id: user.id,
          state: true
        }
      }

      expect(response).to have_http_status(:created)
      expect(FeatureOverride.count).to eq(1)
    end

    it "returns error if feature_id invalid" do
      post "/api/v1/features/999/overrides", params: {
        feature_override: {
          override_type: "user",
          override_id: user.id,
          state: true
        }
      }

      expect(response).to have_http_status(:not_found)
    end

    it "creates a region override" do
      post "/api/v1/features/#{feature.id}/overrides", params: {
        feature_override: {
          override_type: "region",
          override_id: "us-east",
          state: true
        }
      }

      expect(response).to have_http_status(:created)
      expect(FeatureOverride.last.override_type).to eq("region")
    end
  end

  describe "PATCH /api/v1/features/:feature_id/overrides/:id" do
    let!(:override) do
      FeatureOverride.create!(
        feature: feature,
        override_type: "user",
        override_id: user.id,
        state: false
      )
    end

    it "updates override state" do
      patch "/api/v1/features/#{feature.id}/overrides/#{override.id}",
        params: { feature_override: { state: true } }

      expect(response).to have_http_status(:ok)
      expect(override.reload.state).to eq(true)
    end
  end

  describe "DELETE /api/v1/features/:feature_id/overrides/:id" do
    let!(:override) do
      FeatureOverride.create!(
        feature: feature,
        override_type: "user",
        override_id: user.id,
        state: true
      )
    end

    it "deletes the override" do
      expect {
        delete "/api/v1/features/#{feature.id}/overrides/#{override.id}"
      }.to change(FeatureOverride, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
