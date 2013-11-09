class UserJSON < JSONBase 

  def new_session
    build do |json,user|
      json.username user.username
      json.api_key user.generate_key
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
