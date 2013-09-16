class CreateWhitelists < ActiveRecord::Migration
  def change
    create_table :whitelists do |t|
      t.string :branch_name
      t.integer :project_id
      t.integer :num_items

      t.timestamps
    end
  end
end
