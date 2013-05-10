class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :issue
      t.integer :revision_number
      t.datetime :committed_at
      t.string :author
      t.string :message

      t.timestamps
    end
  end
end
