class UserJSON < JSONBase 

  def new_session
    build do |json,user|
      session_key = user.generate_key
      json.id session_key.id
      json.username user.username
      json.api_key session_key.token
    end
  end

  def self.failure_json(err)
    Jbuilder.encode do |json|
      json.username nil
      json.password nil
      json.error err
    end
  end

end
