class Command::Autocomplete < ::Command
  def run
    directory_path, partial_file_name = resolve_directory_and_file(argv[0])
    directory = Node.fetch(directory_path)

    raise InvalidFileError.new(directory_path) unless directory && access.read?(directory)

    nodes = directory.autocomplete_children(partial_file_name)

    output!(nodes.length > 0 ? NodeJSON.new(nodes).names_hash : nil)
  end
end
