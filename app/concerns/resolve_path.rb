module ResolvePath

  def resolve_path(path,cwd="/")
    join_path resolve_path_parts(path,cwd)
  end


  def resolve_directory_and_file(path,cwd="/")
    parts = resolve_path_parts(path,cwd)
    if path[-1] == "/"
      return join_path(parts),""
    else
      return join_path(parts[0..-2]),parts[-1]
    end
  end

  def resolve_path_parts(path,cwd="/")
    path_parts =  generate_path_parts(path,cwd)
    resolve_relative_path_parts(path_parts)
  end

  def join_path(path_parts)
    "/" + path_parts.join("/")
  end

  def generate_path_parts(path,cwd)
    if path.to_s[0] == "/"
      path.to_s.split("/").reject(&:blank?)
    else
      (cwd.to_s.split("/") + path.to_s.split("/")).reject(&:blank?)
    end
  end

  def resolve_relative_path_parts(path_parts)
    idx = 0
    final_path_parts = []
    while idx < path_parts.length
      if path_parts[idx] == ".."
        final_path_parts.pop
      elsif path_parts[idx] != "."
        final_path_parts << path_parts[idx]
      end
      idx += 1
    end
    final_path_parts
  end
end
