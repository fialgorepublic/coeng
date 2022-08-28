# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.string :first_name
      t.string :surname
      t.string :id_number
      t.string :employee_number
      t.string :telephone
      t.string :job_title
      t.integer :department_id
      t.integer :user_type
      t.integer :status
      t.string :auth_token
      t.json :permissions
      t.boolean :is_deleted, default: false
      t.boolean :popup_notifications, default: true
      t.boolean :email_notifications, default: true

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
