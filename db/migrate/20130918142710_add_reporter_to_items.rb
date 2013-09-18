class AddReporterToItems < ActiveRecord::Migration
  def change
    add_column :items, :reporter, :string
  end
end
