class CreatePaths < ActiveRecord::Migration
  def change
    create_table :paths do |t|
      t.string :kind
      t.string :action
      t.string :file
      t.integer :commits_id

      t.timestamps
    end
  end
end
