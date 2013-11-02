class InvalidValidationError < RuntimeError

  attr_reader :errors

  def initialize(errors)
    @errors = errors
  end

  def to_s
    msg = errors.full_messages.join(", ")
    "Error: #{msg}"
  end
end
