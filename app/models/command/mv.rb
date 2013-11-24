class Command::Mv < ::Command
  def run
    source_node_path = resolve_path(argv[0] || ".")
    source_node = Node.fetch(node_path)

    destination_node_path = resolve_path(argv[1] || ".")
    destination_node = Node.fetch(destination_node_path)

    raise InvalidFileError.new(node_path) unless access.read?(source_node) && (!destination_node || 

    nodes = node.directory? ? node.children : [ node ]

    output!(NodeJSON.new(nodes).list_hash)
  end
end
