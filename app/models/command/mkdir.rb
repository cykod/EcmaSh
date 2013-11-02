class Command::Mkdir < ::Command
  def run
    parts = resolve_path_parts(argv[0])
    dirname = parts[-1]

    node = Node.fetch(join_path(parts[0..-2]))

    raise InvalidFileError.new(argv[0]) unless node && user.can_write?(node) && node.directory?

    dirnode = DirectoryNode.create(name: dirname, parent: node, user: user)

    raise InvalidValidationError.new(dirnode.errors) unless dirnode.valid?

    output!(NodeJSON.new(dirnode).list_hash)
  end
end
