# app/controllers/api/v1/features_controller.rb
module Api
  module V1
    class FeaturesController < ApplicationController
      before_action :set_feature, only: [ :show, :update ]
      before_action :set_feature_payload, only: [ :evaluate ]

      # GET /api/v1/features
      def index
        render json: Feature.all, status: :ok
      end

      # GET /api/v1/features/:id
      def show
        render json: @feature, status: :ok
      end

      # POST /api/v1/features
      def create
        feature = FeatureControlEngine::MutationService.create_feature(feature_params)
        render json: feature, status: :created
      end

      # PATCH /api/v1/features/:id
      def update
        FeatureControlEngine::MutationService.update_feature(@feature, feature_params)
        render json: @feature, status: :ok
      end

      # GET /api/v1/features/:id/evaluate
      def evaluate
        user = params[:user_id].present? ? User.find(params[:user_id]) : nil
        region = params[:region]
        enabled = FeatureControlEngine::Evaluator.new(
          user: user,
          region: region,
          override_index: @feature_payload[:overrides],
          default_state: @feature_payload[:default_state]
        ).call

        render json: { feature: @feature_payload[:name], enabled: enabled }, status: :ok
      end

      private

      def set_feature
        @feature = Feature.find(params[:id])
      end

      def set_feature_payload
        @feature_payload = FeatureControlEngine::CacheStore.fetch(params[:id])
      end

      def feature_params
        params.require(:feature).permit(:name, :default_state, :description)
      end
    end
  end
end
