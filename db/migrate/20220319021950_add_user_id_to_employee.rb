class AddUserIdToEmployee < ActiveRecord::Migration[7.0]
  def change
    add_column :employees, :user_id, :integer
    add_foreign_key :employees, :users
  end
end
