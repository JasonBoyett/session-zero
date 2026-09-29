class CreateLines < ActiveRecord::Migration[8.1]
  def change
    create_table :lines do |t|
      t.timestamps

      t.string :title
      t.text :description
      t.boolean :is_annonymous

      t.references :game, null: false, foreign_key: true
      t.references :player_profile, null: false, foreign_key: true
    end
  end
end
