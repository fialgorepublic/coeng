class AuthenticateUser
  prepend SimpleCommand
  
  def initialize(email, password)
    @email = email
    @password = password
  end
  
  def call
    { detail:  'User' , id: user.id, token: JsonWebToken.encode(user_id: user.id) } if user
  end
  
  private
  
  attr_accessor :email, :password
  
  def user
    user = User.find_by_email(email)
    return user if user && user.valid_password?(password)
    errors.add :user_authentication, 'Invalid Credentials'
    nil
  end
end