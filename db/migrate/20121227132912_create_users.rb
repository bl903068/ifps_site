class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :first_name
      t.string :labo
      t.string :email

      t.timestamps
    end
  end
end
