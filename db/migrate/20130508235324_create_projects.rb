class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :url_path
      t.integer :base_revision
      t.integer :last_revision
      t.boolean :active

      t.timestamps
    end
  end
end
