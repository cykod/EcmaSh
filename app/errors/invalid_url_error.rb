class InvalidURLError < RuntimeError

  attr_reader :path

  def initialize(url,code)
    @url = url
    @code = code
  end

  def to_s
    "Error: #{@url} returned status #{@code}"
  end
end
