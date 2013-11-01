class CommandsController < ApplicationController

  def create
    result = Command.run(current_user,command_id,command_args)

    render json: result
  end
    

  protected

  def command_id
    params.permit(:id)[:id]
  end

  def command_args
    params.permit(argv: [])[:argv]
  end

end
