class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.string :requester_name
      t.string :requester_extension
      t.string :requester_phone
      t.string :requester_id
      t.string :requester_mail
      t.string :requester_type
      t.string :student_id
      t.string :student_assosiation
      t.string :work_location
      t.string :work_building
      t.string :work_type
      t.text :work_description

      t.timestamps
    end
  end
end
