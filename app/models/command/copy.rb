class Command::Copy < ::Command
  def run
    source_node_path = resolve_path(argv[0])
    source_node = Node.fetch(source_node_path)

    destination_node_path = resolve_path(argv[1])
    destination_node = Node.fetch(destination_node_path)

    raise InvalidFileError.new(source_node_path) unless access.write?(source_node)

    # check if destination node exists, and is a directory we can write to
    if(destination_node && access.write?(destination_node))
      if destination_node.directory?
        source_node.parent = destination_node
        source_node.save
        output!(NodeJSON.new([source_node]).list_hash)
        return nil
      else
        destination_directory = destination_node.parent.fullpath
        file_name = destination_node.name
        destination_node.destroy
        result = source_node.copy(destination_directory,file_name)
        output!(NodeJSON.new([result]).list_hash)
        return source_node
      end
    else 
      directory, file_name = resolve_directory_and_file(argv[1])

      destination_directory = Node.fetch(directory)

      if(access.write?(destination_directory)) 
        result = source_node.copy(destination_directory,file_name)
        output!(NodeJSON.new([result]).list_hash)
        return source_node
      else
        raise CantWriteError.new(destination_node_path)
      end
    end
    
    # or if destination node does not exist, but 

  end
end
