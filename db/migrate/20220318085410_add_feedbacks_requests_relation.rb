class AddFeedbacksRequestsRelation < ActiveRecord::Migration[7.0]
  def change
    change_table :feedbacks do |t|
      t.belongs_to :request, null: false, foreign_key: true
    end
  end
end
