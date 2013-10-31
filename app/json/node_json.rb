class NodeJSON < JSONBase 

  def list
    build do |json,node|
      json.fullpath node.fullpath
      json.name node.name
      json.directory node.directory?
    end
  end

end
