class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :idCard
      t.string :fullName
      t.string :email
      t.boolean :status

      t.timestamps
    end
  end
end
