class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def require_user
    if !current_user
      render nothing: true, status: 403
      return false
    end
  end
end
