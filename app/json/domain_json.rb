class DomainJSON < JSONBase 

  def details
    build do |json,domain|
      json.name domain.name
      json.directory domain.directory_node.fullpath
    end
  end


end
