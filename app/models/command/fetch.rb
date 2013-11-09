class Command::Fetch < ::Command
  def run
    node_path = resolve_path(".")
    directory = Node.fetch(node_path)

    raise CantWriteError.new(node_path) unless access.write_directory?(directory) 

    node = directory.fetch(argv[0])

    output!(NodeJSON.new(node).list_hash)
  end
end
