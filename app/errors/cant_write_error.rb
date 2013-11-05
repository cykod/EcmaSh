class CantWriteError < RuntimeError

  attr_reader :path

  def initialize(path)
    @path = path
  end

  def to_s
    "Error: no permission to write to #{path}"
  end
end
