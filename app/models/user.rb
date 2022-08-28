class User < ApplicationRecord
  USER_TYPE_NAMES = ActiveSupport::HashWithIndifferentAccess.new(
    { admin: 'Super Admin', admin: 'Admin', manager: 'Manager', user: 'User' }
  ).freeze
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :user_type, :first_name, :surname, :id_number, :employee_number, presence: true, unless:  :super_admin?, on: :create

  enum user_type: %i[super_admin admin manager user]
  enum status: %i[active inactive]

  scope :active_users, -> { where(is_deleted: false ) }

  def user_type_name
    USER_TYPE_NAMES[user_type]
  end

end
