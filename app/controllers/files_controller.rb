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

  def show
    node = Node.fetch("/home/" + params[:directory].to_s)

    access = Access.new(current_user_id)

    if access.read?(node)
      if node.directory?
        # show a listing
      elsif has_content?
        send_data node.content, :type => node.content_type, :disposition => 'inline', name: node.name
      else
        redirect_to node.file_url
      end
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
