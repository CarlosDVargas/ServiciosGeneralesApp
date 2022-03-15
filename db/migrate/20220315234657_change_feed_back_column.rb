class ChangeFeedBackColumn < ActiveRecord::Migration[7.0]
  def change
    change_column :feedbacks, :observations, :text, limit: 300
  end
end
