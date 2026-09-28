class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.timestamps

      t.string :name
      t.string :profile_picture
    end
  end
end
