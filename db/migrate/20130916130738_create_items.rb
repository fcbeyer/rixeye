class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :whitelist_id
      t.string :issue
      t.text :comment

      t.timestamps
    end
  end
end
