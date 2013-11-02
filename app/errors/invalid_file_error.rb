class InvalidFileError < RuntimeError

  attr_reader :path

  def initialize(path)
    @path = path
  end

  def to_s
    "Error: no file or directory named #{path}"
  end
end
