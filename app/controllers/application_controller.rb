# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { errors: [ e.message ] }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_content
  end

  rescue_from ActiveRecord::RecordNotUnique do |e|
    render json: { errors: [ e.message ] }, status: :unprocessable_content
  end

  rescue_from ActionController::ParameterMissing do |e|
    render json: { errors: [ e.message ] }, status: :bad_request
  end
end
