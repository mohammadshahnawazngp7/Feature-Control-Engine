require 'rails_helper'

RSpec.describe "Features API", type: :request do
  let!(:group) { Group.create!(name: "Beta") }
  let!(:user) { User.create!(name: "John", group: group) }
  let!(:feature1) { Feature.create!(name: "new_dashboard", default_state: false) }
  let!(:feature2) { Feature.create!(name: "dark_mode", default_state: true) }

  describe "GET /api/v1/features" do
    it "returns all features" do
      get "/api/v1/features"
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.size).to eq(2)
    end
  end

  describe "GET /api/v1/features/:id" do
    it "returns single feature" do
      get "/api/v1/features/#{feature1.id}"
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["name"]).to eq("new_dashboard")
    end
  end

  describe "POST /api/v1/features" do
    it "creates a feature" do
      post "/api/v1/features", params: {
        feature: { name: "beta_search", default_state: false }
      }

      expect(response).to have_http_status(:created)
    end

    it "returns error for invalid params" do
      post "/api/v1/features", params: {
        feature: { default_state: true }
      }

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PATCH /api/v1/features/:id" do
    it "updates a feature" do
      patch "/api/v1/features/#{feature1.id}", params: {
        feature: { default_state: true }
      }

      expect(response).to have_http_status(:ok)
      expect(feature1.reload.default_state).to eq(true)
    end
  end
end
