class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection

  protect_from_forgery with: :exception

  private
  def valid_request_origin?
    super || request.origin == Rails.application.config.x.client_url
  end
end
