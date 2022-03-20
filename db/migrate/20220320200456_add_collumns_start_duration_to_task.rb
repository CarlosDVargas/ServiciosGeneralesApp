class AddCollumnsStartDurationToTask < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :started_at, :datetime
    add_column :tasks, :finished_at, :datetime
    add_column :tasks, :time_duration, :integer
  end
end
