class Api::V1::AuthController < Api::BaseController
  skip_before_action :authenticate_user, only: [:authenticate]
  
  def authenticate
    command = AuthenticateUser.new(params[:email], params[:password]).call

    if command.success?
        user = User.find(command.result[:id])
        return json_error_response('This Account has been disabled. Please contact your Administrator.') if user.present? and user.inactive?
        user.update(auth_token: command.result[:token])
        json_success_response('Login Successful', { user: user })
    else
      json_error_response('Your Email or Password is incorrect. Please try again.')
    end
  end

end