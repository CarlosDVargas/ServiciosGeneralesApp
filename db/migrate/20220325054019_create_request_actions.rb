class CreateRequestActions < ActiveRecord::Migration[7.0]
  def change
    create_table :request_actions do |t|
      t.integer :request_id
      t.integer :user_id
      
      t.timestamps
    end
  end
end
