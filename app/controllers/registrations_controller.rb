class RegistrationsController < ApplicationController

  def create
    @registration = Registration.new(user_params)

    if @registration.valid?
      @user = @registration.register!
      render json: UserJSON.new(@user).new_session_json
    else
      render json: UserJSON.failure_json("Invalid Login"), status: :unauthorized
    end
  end

  def show
    @registration = Registration.new(user_params)

    if @registration.valid? 
      render json: { error: nil}
    else
      render json: { error: @registration.errors.full_messages.join(", ") } 
    end
  end


  protected

  def user_params
    params.permit(:id, :username,:password,:email)
  end
end
