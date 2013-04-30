class ApplicationController < ActionController::Base
  include Errship3::Rescuers
  include Errship3::ActiveRecord::Rescuers
  add_breadcrumb :home, :root_path
  before_filter :dev_tools if Rails.env.development?
  protect_from_forgery


  def user_for_paper_trail
    user_signed_in? ? current_user : 'Public user' # or whatever
  end

  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    #I18n.locale = extract_locale_from_tld || I18n.default_locale
  end

  # Get locale from top-level domain or return nil if such locale is not available
  # You have to put something like:
  #   127.0.0.1 application.com
  #   127.0.0.1 application.it
  #   127.0.0.1 application.pl
  # in your /etc/hosts file to try this out locally
  def extract_locale_from_tld
    parsed_locale = request.host.split('.').last
    I18n.available_locales.include?(parsed_locale.to_sym) ? parsed_locale : nil
  end


  protected

  def log_exception(exception)
    application_trace = ActionDispatch::ExceptionWrapper.new(env, exception).application_trace
    application_trace.map! { |t| "  #{t}\n" }
    logger.error "\n#{exception.class.name} (#{exception.message}):\n#{application_trace.join}"
  end

  def after_sign_in_path_for resource
    if resource.is_a?(User) && resource.respond_to?(:blocked) && resource.blocked
      sign_out resource
      flash[:alert] = "Your account is blocked. Retry when an admin unblock it."
      new_user_session_path
    else
      super
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    redirect_to root_path, :alert => exception.message
  end

  def no_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def dev_tools
    Rack::MiniProfiler.authorize_request
  end
end
