class FilesController < ApplicationController
  include ResolvePath

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
      elsif node.has_content?
        headers["Access-Control-Allow-Origin"] = "*"
        send_data node.content, :type => node.content_type, :disposition => 'inline', name: node.name
      else
        redirect_to node.file(:original)
      end
    else
      return render nothing: true, status: 404
    end
  end

  def update
    node_path = "/home/" + params[:directory].to_s
    node = Node.fetch(node_path)

    access = Access.new(current_user_id)

    if access.write?(node) && !node.directory? && node.text?
      node.content = params[:content].to_s
      return render nothing: true, status: :accepted
    end

    directory, file_name = resolve_directory_and_file(node_path,"")
    directory_node = Node.fetch_directory(directory)

    if directory_node && access.write?(directory_node)
      node = directory_node.empty_file(file_name)
      return render nothing: true, status: 404 unless node.text?
      node.content = params[:content].to_s
      node.save
      return render nothing: true, status: :accepted
    else
      return render nothing: true, status: 404
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
