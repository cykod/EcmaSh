class SessionsController < ApplicationController

  def create
    @user = User.login(session_params[:username],
                       session_params[:password])

    if @user
      render json: UserJSON.new(@user).new_session_json
    else
      render json: UserJSON.failure_json("Invalid Login"), status: :unauthorized
    end
  end

  def destroy
    if current_user
      current_user.destroy_key(logout_param[:token])
    end
    render json: { status: "none" }, status: :ok
  end


  protected

  def session_params
    params.permit(:username,:password)
  end

  def logout_param
    params.permit(:token)
  end
end
