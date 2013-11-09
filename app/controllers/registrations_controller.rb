class RegistrationsController < ApplicationController

  def create
    @user = User.create(user_params)

    if @user.valid?
      render json: UserJSON.new(@user).new_session_json
    else
      render json: UserJSON.failure_json("Invalid Login"), status: :unauthorized
    end
  end

  def show
    User.where(username: user_params[:id]).first

    render json: {}
  end


  protected

  def user_params
    params.permit(:id, :username,:password,:email)
  end
end
