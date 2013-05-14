class AddLastruntimeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :last_run_time, :datetime
  end
end
