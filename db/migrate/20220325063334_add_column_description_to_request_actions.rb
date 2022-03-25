class AddColumnDescriptionToRequestActions < ActiveRecord::Migration[7.0]
  def change
    add_column :request_actions, :description, :string
  end
end
