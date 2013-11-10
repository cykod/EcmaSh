class ApplicationController < ActionController::Base

  def require_user
    if !current_user
      render nothing: true, status: 403
      return false
    end
  end

  def current_user_id
    @current_user_id = UserKey.authenticate(params[:token]  || cookies[:token]).try(:user_id)
  end


  def current_user
    @current_user ||= User.where(id: current_user_id).first
  end
end
