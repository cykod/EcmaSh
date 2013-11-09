class SessionsController < ApplicationController

  def create
    @user = User.login(session_params[:username],
                       session_params[:password])

    if @user
      render json: UserJSON.new(@user).new_session_json
    else
      render nothing: true, status: :unauthorized
    end
  end


  protected

  def session_params
    params.permit(:username,:password)
  end
end
