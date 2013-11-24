class Command::Rm < ::Command
  def run
    node_path = resolve_path(argv[0] || ".")
    node = Node.fetch(node_path)

    raise InvalidFileError.new(node_path) unless node
    raise CantWriteError unless access.write?(node)

    node.destroy

    output!(NodeJSON.new(node).list_hash)
  end
end
