class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.string :title
      t.string :type
      t.string :nameofpublication
      t.string :resume
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :publications, :title, [:user_id, :created_at]
  end
end
