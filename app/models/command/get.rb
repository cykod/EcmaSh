class Command::Get < ::Command
  def run
    response = HTTParty.get(URI.encode(argv[0].to_s.strip))
    output!(response.parsed_response)
  end
end
