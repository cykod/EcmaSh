class Command::Show < ::Command
  def run
    node_path = resolve_path(argv[0])

    node = Node.fetch(node_path)

    raise InvalidFileError.new(argv[0]) unless access.read?(node) && !node.directory?

    output!(NodeJSON.new(node).details_hash)
  end
end
