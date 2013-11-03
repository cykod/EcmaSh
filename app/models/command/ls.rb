class Command::Ls < ::Command
  def run
    node = Node.fetch(resolve_path(argv[0] || "."))

    raise InvalidFileError.new(argv[0]) unless node && user.can_read?(node)

    nodes = node.directory? ? node.children : [ node ]

    output!(NodeJSON.new(nodes).list_hash)
  end
end
