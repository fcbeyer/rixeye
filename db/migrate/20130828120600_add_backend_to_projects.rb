class AddBackendToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :scm_type, :string
  end
end
