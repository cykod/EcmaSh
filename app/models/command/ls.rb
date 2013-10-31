class Command::Ls < ::Command
  def run
    node = Node.fetch(argv[0])

    raise "Can't read" unless node && user.access(node).read?

    nodes = node.directory? ? node.children : [ node ]

    output!(NodeJSON.new(nodes).list_hash)
  end
end
