class Command::Get < ::Command
  def run
    url = URI.encode(argv[0].to_s.strip)
    response = HTTParty.get(url)

    if response.code == 404 || response.code == 500
      raise InvalidURLError.new(url,response.code)
    end

    content_type = response.content_type

    if content_type == "application/octet-stream"
      content_type =  FileNode.type_for_name(url)
    end
    

    if content_type == "text/json" || content_type == "application/json"
      output!(JSON.parse(response.body))
    elsif content_type == "text/xml" || content_type == "application/xml" 
      output!(Hash.from_xml(response.body))
    else
      output!({ "content" => response.body })
    end
  end
end
