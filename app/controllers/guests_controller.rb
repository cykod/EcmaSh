class GuestsController < ApplicationController

  def create
    @user = Guest.generate!
    render json: UserJSON.new(@user).new_session_json
  end

end
