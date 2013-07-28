class AddAutopollToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :autopoll, :boolean, :default => true
  end
end
