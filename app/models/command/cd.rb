class Command::Cd < ::Command
  def run
    node_path = resolve_path(argv[0] || ".")
    node = Node.fetch(node_path)

    raise InvalidFileError.new(node_path) unless node && user.can_read?(node)

    output!(NodeJSON.new(node).list_hash)
  end
end
