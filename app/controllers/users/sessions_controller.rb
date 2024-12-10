# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include SessionsFix

  respond_to :json
  # before_action :configure_sign_in_params, only: [:create]

  private
  def respond_with(current_user, _opts = {})
    render json: { user: current_user }, status: 200
  end

  def respond_to_on_destroy
    if request.headers["Authorization"].present?
      jwt_payload = JWT.decode(request.headers["Authorization"].split(" ").last, Rails.application.credentials.devise_jwt_secret_key!).first
      current_user = User.find(jwt_payload["sub"])
    end

    if current_user
      render json: { message: "Logged out successfully." }, status: 200
    else
      render json: { message: "Couldn't find an active session." }, status: 401
    end
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
