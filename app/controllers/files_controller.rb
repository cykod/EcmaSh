class FilesController < ApplicationController

  def create
    result = Command.run(current_user_id,
                         "upload",
                         context_args,
                         command_args)

    if result.is_a?(RuntimeError) 
      render json: { error: result.to_s }, status: 406
    else
      render json: { result: result }
    end
  end

  protected

  def context_args
    { CWD: "/home/" + params[:directory].to_s }
  end

  def command_args
    params[:files]
  end
end
