Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :bcrypt
  manager.failure_app = SessionsController

  manager.default_serializers :session, :cookie

  manager.serializers.update(:session) do
    def serialize(user)
      user.email
    end

    def deserialize(id)
      User.get(id)
    end
  end
end

Warden::Strategies.add(:bcrypt) do
  def valid?
    params[:username] || params[:password]
  end

  def authenticate!
    return fail! unless user = User.get(params[:username])

    if user.crypted_password == Digest::MD5.hexdigest(params[:password])
      success!(user)
    else
      errors.add(:username, "Username or Password incorrect")
      fail!
    end
  end
end