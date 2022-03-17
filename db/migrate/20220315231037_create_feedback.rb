class CreateFeedback < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.string :observations
      t.integer :satisfaction
      
      t.timestamps
    end
  end
end
