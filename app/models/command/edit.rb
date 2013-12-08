class Command::Edit < ::Command
  def run
    node_path = resolve_path(argv[0])

    node = Node.fetch(node_path)

    if !node
       directory, file_name = resolve_directory_and_file(argv[1])
       directory_node = Node.fetch(directory)
    end

    raise InvalidFileError.new(argv[0]) unless access.write?(node) && !node.directory?
    raise InvalidFileError.new(argv[0]) unless node.text?

    output!(NodeJSON.new(node).details_hash)
  end
end
