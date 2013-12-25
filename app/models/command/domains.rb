class Command::Domains < ::Command
  def run
    cmd = argv[0]

    case cmd
    when 'list'
      node = DirectoryNode.fetch(resolve_path(argv[1]))
      self.list(argv[1].present? ? node : nil)
    when 'add'
      domain =  argv[1].to_s.strip
      node = DirectoryNode.fetch(resolve_path(argv[2]))
      self.add(domain,node)
    when "del"
      domain =  argv[1].to_s.strip
      self.del(domain)
    else
      self.help
    end
  end

  def help
    output!({
      help: true,
      details: "call list, add or del + domain name to"
    })
  end

  def add(domain,node)
    access =  Access.new(user)

    if access.write?(node)
      domain = Domain.create(directory_node: node, user: user, name: domain)
      return output!(DomainJSON.new(domain).details_hash) if domain.valid?
    end
  end

  def del(domain)
    d = user.domains.where(name: domain).first

    if d
      d.destroy
      return output!(DomainJSON.new(d).details_hash)
    end
  end

  def list(node)

    domains = if node
                node.domains
              else
                user.domains
              end
    return output!(DomainJSON.new(domains).details_hash)
  end
end
