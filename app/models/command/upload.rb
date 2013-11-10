class Command::Upload < ::Command
  def run
    node_path = resolve_path(".")

    directory = Node.fetch(node_path)

    files = self.argv
    self.argv = files.map(&:original_filename)

    raise CantWriteError.new(node_path) unless access.write_directory?(directory) 

    nodes = [] 
    files.each do |file|
      nodes << FileNode.create(file: file, user: user, parent: directory)
    end

    output!(NodeJSON.new(nodes).list_hash)
  end
end
