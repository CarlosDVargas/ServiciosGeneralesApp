class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.belongs_to :employee, null: false, foreign_key: true
      t.belongs_to :request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
