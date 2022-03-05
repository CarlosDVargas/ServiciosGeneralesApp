class RemovePasswordFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :password, :string
  end
end
