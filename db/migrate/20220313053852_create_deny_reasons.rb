class CreateDenyReasons < ActiveRecord::Migration[7.0]
  def change
    create_table :deny_reasons do |t|
      t.string :description
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
