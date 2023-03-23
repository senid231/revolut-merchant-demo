# frozen_string_literal: true

class ApplicationController < ActionController::Base
  delegate :current_page?, to: :view_context
  helper_method :current_menu, :current_path

  rescue_from RevolutMerchant::Errors::ApiError, with: :handle_server_error

  private

  def handle_server_error(error)
    log_error(error)
    if current_page?(customers_path)
      render file: Rails.public_path.join('500.html'), status: 500, layout: false
    else
      flash[:alert] = "Something went wrong <#{error.class}> #{error.message}"
      redirect_back(fallback_location: customers_path)
    end
  end

  def log_error(error, skip_backtrace: false, causes: [])
    logger.error { "<#{error.class}> #{error.message}\n#{error.backtrace.join("\n") unless skip_backtrace}" }
    return if error.cause.nil? || error == error.cause || causes.include?(error)

    new_causes = causes + [error]
    log_error(error, skip_backtrace:, causes: new_causes)
  end

  def current_menu
    nil
  end

  def current_path
    url_for(action: action_name)
  end
end
