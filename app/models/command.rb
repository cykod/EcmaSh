class Command < ActiveRecord::Base
  attr_reader :output
  attr_accessor :context

  include ResolvePath

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
    rescue InvalidFileError, InvalidValidationError, CantWriteError, InvalidURLError => e
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
    super(path,context['CWD'])
  end

  def resolve_directory_and_file(path)
    super(path,context['CWD'])
  end

  def resolve_path_parts(path,cwd=nil)
    super(path,cwd || context['CWD'])
  end

end
