class Api::V1::UsersController < ApplicationController
  def index
    if check_headers && User.find_by(email: request.env["HTTP_EMAIL"])
      registration_error = {
        error: "Choose a different Email",
        status: 400
      }
      render :json => registration_error, :status => :bad_request
    elsif
      if request.env["HTTP_PASSWORD"] == request.env["HTTP_PASSWORD_CONFIRMATION"]
      token = "C"+ SecureRandom.urlsafe_base64

      user = User.create(
        first_name: request.env["HTTP_FIRST_NAME"],
        last_name: request.env["HTTP_LAST_NAME"],
        email: request.env["HTTP_EMAIL"],
        password: request.env["HTTP_PASSWORD"],
        password_confirmation: request.env["HTTP_PASSWORD_CONFIRMATION"],
        api_key: token,
      )

      render json: {
        "first_name": user.first_name,
        "last_name": user.last_name,
        "email": user.email,
        "api_key": user.api_key
      }, status: :created

      else
        render json: {
          "error": "Password and Password Confirmation do not match"
        }, status: :bad_request
      end
    end
  end

  private

  def check_headers
    headers.each do | header |
      if header != nil
        return true
      end
    end
  end

  def headers
    [
      request.env["HTTP_FIRST_NAME"],
      request.env["HTTP_LAST_NAME"],
      request.env["HTTP_EMAIL"],
      request.env["HTTP_PASSWORD"],
      request.env["HTTP_PASSWORD_CONFIRMATION"]
    ]
  end
end
