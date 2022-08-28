class Api::V1::UsersController < Api::BaseController
  before_action :get_user, only: %i[update show destroy send_user_invite]
  
  def index
    @users = User.filter(params[:search]).includes(:departments)
                .order("#{params[:sort]} #{params[:order]}")
                .page(pagination_params[:page])
                .per(pagination_params[:limit])
    
    json_success_response('Listing All User.', @users)
  end
  
  def create
    user = User.new(user_params)
    binding.pry
    user.permissions = JSON.parse(params[:permissions]) if params[:permissions].present?
    if user.save
      json_success_response('User Successfully Created.', user)
    else
      json_error_response('Something Went Wrong.', user.errors.full_messages)
    end
  end
  
  def show
    json_success_response('User Details.', @user)
  end
  
  def update
    permissions = JSON.parse(params[:permissions]) if params[:permissions].present?
    if @user.update(permissions.present? ? user_params.merge(permissions: permissions) : user_params)
      @user.update(quick_easy_id: nil) if params[:quick_easy_id].blank?
      json_success_response('User Successfully Updated.',
                            @user)
    else
      json_error_response('Something Went Wrong.',
                          @user.errors.full_messages)
    end
  end

  def check_user_token
    if current_user.present?
      json_success_response('User Authenticated.', current_user)
    else
      json_error_response('Token Expired.', current_user.errors.full_messages)
    end
  end
  
  def destroy

    if @user.update(is_deleted: true, quick_easy_id: nil)
      json_success_response('User Successfully Deleted.', @user)
    else
      json_error_response('Something Went Wrong.', @user.errors.full_messages)
    end
  end
  
  def logout
    current_user.update(auth_token: nil)
    json_success_response('Logged Out.')
  end
  
  def user_details
    processing_steps = ProcessingStep.all
    department_emails = DepartmentEmail.all
    sales_reps = CpyStaff.select(:staffid, :listname)
    positions = Department.positions.map { |pos| positions_arr = { key: pos[0], value: pos[1] } }
    user_types = User.user_types.map { |type| types = { key: type[0], value: type[1] } }
    status = User.statuses.map { |stat| status_arr = { key: stat[0], value: stat[1] } }
    json_success_response('Profile Details.', { sales_reps: sales_reps, department: processing_steps, department_emails: department_emails, positions: positions, status: status, user_types: user_types })
  end
  
  def send_user_invite
    UserMailer.send_user_invite(@user).deliver_now
    json_success_response('Details Sent Successfully', @user)
  end

  def verify_pin
    user = User.find(params[:user_id])
    if user.pin == params[:pin]
      json_success_response('Pin Verified.')
    else
      json_error_response('Pin is invalid.')
    end
  end
  
  private
  
  def user_params
    params.permit(:first_name, :email, :surname, :telephone, :employee_number, :password,:job_title,
                  :employee_number, :password_confirmation, :user_type, :status, :email_notifications, :popup_notifications,
                  :id_number, permissions: {})
  end
  
  def get_user
    @user = User.find(params[:id])
  end

  def user_complete_object
    {users: @users.collect(&:complete_object), total_users: User.filter(params[:search]).count }
  end
end