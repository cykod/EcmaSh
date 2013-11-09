class Command::Cd < ::Command
  def run
    node_path = resolve_path(argv[0] || ".")
    node = Node.directories.fetch(node_path)

    raise InvalidFileError.new(node_path) unless access.read?(node)

    output!(NodeJSON.new(node).list_hash)
  end
end
