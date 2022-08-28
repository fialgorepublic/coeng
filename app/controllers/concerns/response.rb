module Response
  
  def json_success_response(message, data = {})
    render json: { success: true, message: message, data: data }
  end
  
  def json_error_response(message, errors = {})
    render json: { success: false, message: message, errors: errors }
  end
  
end
