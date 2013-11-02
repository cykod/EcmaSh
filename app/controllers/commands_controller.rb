class CommandsController < ApplicationController
  before_filter :require_user

  def create
    result = Command.run(current_user,command_id,context_args,command_args)

    if result.is_a?(RuntimeError) 
      render json: { error: result.to_s }, status: 406

    else
      render json: result
    end
  end
    

  protected

  def command_params
    params.permit(:id, argv: [], context: {})
  end

  def command_id
    command_params[:id]
  end

  def command_args
    command_params[:argv]
  end

  def context_args
    command_params[:context] || {}
  end

end
