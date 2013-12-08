class Command::Cp < ::Command
  def run

    # get the source node
    source_node_path = resolve_path(argv[0])
    source_node = Node.fetch(source_node_path)

    # get get the destination node and directory
    destination_node_path = resolve_path(argv[1])
    destination_node = Node.fetch(destination_node_path)

    if !destination_node
      destination_directory_name, destination_file_name = resolve_directory_and_file(argv[1])
      destination_directory = Node.fetch(destination_directory_name)
    elsif destination_node.directory?
      destination_directory = destination_node
      destination_file_name = source_node.name
      destination_node = nil
    else
      destination_directory = destination_node.parent
      destination_file_name = destination_node.name
    end

    raise InvalidFileError.new(source_node_path) unless access.read?(source_node)
    raise InvalidFileError.new(destination_directory_name) unless destination_directory && access.write?(destination_directory)

    destination_node.destroy if destination_node

    result_node = source_node.copy(destination_directory,destination_file_name)

    output!(NodeJSON.new([result_node]).list_hash)
    return source_node
  end
end
