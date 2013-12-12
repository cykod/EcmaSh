class InvalidFileError < RuntimeError

  attr_reader :path

  def initialize(path,msg=nil)
    @path = path
    @msg = msg || "no file or directory named"
  end

  def to_s
    "Error: #{@msg} #{@path}"
  end
end
