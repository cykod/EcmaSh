class UserJSON < JSONBase 

  def new_session
    build do |json,user|
      json.username user.username
      json.api_key user.generate_key
    end
  end

end
