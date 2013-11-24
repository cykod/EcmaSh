class Command < ActiveRecord::Base
  attr_reader :output
  attr_accessor :context

  belongs_to :user

  scope :successful, -> { where(successful: true) }


  def output!(json)
    @output = json
    self
  end

  @@commands = Dir.glob(Rails.root.join("app/models/command/*.rb")).map do |file|
    file =~ /(\w+).rb$/
    $1.present? ? $1.to_sym : nil
  end.compact

  def self.valid_command?(command)
    @@commands.include?(command.to_sym)
  end

  def self.command_class(command)
    "Command::#{command.to_s.camelcase}"
  end

  def self.run(user_id,command_name,context,argv = [])
    user_id = user_id.id if user_id.is_a?(User)
    command = nil

    return InvalidCommandError.new(command_name) unless valid_command?(command_name)

    begin 
      command = Command.new(user_id: user_id,
                            context: (context || {}).stringify_keys,
                            type: command_class(command_name),
                            successful: true,
                            argv: argv || [])
      command.run
    rescue InvalidFileError, InvalidValidationError, CantWriteError => e
      command.update_attributes(successful: false)
      return e
    end

    command.save.inspect
    command.output
  end

  def access
    @access ||= Access.new(self.user_id)
  end


  def resolve_path(path)
    join_path resolve_path_parts(path)
  end

  def resolve_directory_and_file(path)
    parts = resolve_path_parts(path)
    if path[-1] == "/"
      return join_path(parts),""
    else
      return join_path(parts[0..-2]),parts[-1]
    end
  end

  def join_path(path_parts)
    "/" + path_parts.join("/")
  end

  def resolve_path_parts(path)
    path_parts =  generate_path_parts(path)
    resolve_relative_path_parts(path_parts)
  end


  private

  def generate_path_parts(path)
    if path[0] == "/"
      path.to_s.split("/").reject(&:blank?)
    else
      (context["CWD"].to_s.split("/") + path.to_s.split("/")).reject(&:blank?)
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
