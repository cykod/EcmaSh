class Command::Edit < ::Command
  def run
    node_path = resolve_path(argv[0])

    node = Node.fetch(node_path)

    if !node
      directory, file_name = resolve_directory_and_file(argv[0])
      directory_node = Node.fetch(directory)
      raise InvalidFileError.new(argv[0]) unless access.write_directory?(directory_node)
      node = directory_node.empty_file(file_name) 
      raise InvalidFileError.new(argv[0]) unless node.text?
    else 
      raise InvalidFileError.new(argv[0]) unless access.write?(node) && !node.directory?
      raise InvalidFileError.new(argv[0]) unless node.text?
    end

    output!(NodeJSON.new(node).details_hash)
  end
end
