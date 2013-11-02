class InvalidCommandError < RuntimeError

  attr_reader :command_name

  def initialize(command_name)
    @command_name = command_name
  end

  def to_s
    "Error: invalid command #{command_name}"
  end
end
