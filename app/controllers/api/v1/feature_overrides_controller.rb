# app/controllers/api/v1/feature_overrides_controller.rb
module Api
  module V1
    class FeatureOverridesController < ApplicationController
      before_action :set_feature
      before_action :set_override, only: [ :update, :destroy ]

      # POST /api/v1/features/:feature_id/overrides
      def create
        override = FeatureControlEngine::MutationService.create_override(@feature, override_params)
        render json: override, status: :created
      end

      # PATCH /api/v1/features/:feature_id/overrides/:id
      def update
        FeatureControlEngine::MutationService.update_override(@override, override_params)
        render json: @override, status: :ok
      end

      # DELETE /api/v1/features/:feature_id/overrides/:id
      def destroy
        @override.destroy
        head :no_content
      end

      private

      def set_feature
        @feature = Feature.find(params[:feature_id])
      end

      def set_override
        @override = @feature.feature_overrides.find(params[:id])
      end

      def override_params
        params.require(:feature_override).permit(:override_type, :override_id, :state)
      end
    end
  end
end
