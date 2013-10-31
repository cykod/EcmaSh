class Command < ActiveRecord::Base
  attr_reader :output

  belongs_to :user


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

  def self.run(user,command,*args)

    raise "Bad Command"unless valid_command?(command)

    command = Command.create(user: user,
                             type: command_class(command),
                             argv: args).run

    command.output
  end


end
