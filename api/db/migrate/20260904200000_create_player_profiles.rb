class CreatePlayerProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :player_profiles do |t|
      t.timestamps

      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true

      t.string :character_name
      t.text :character_description
      t.string :character_image
      t.string :character_sheet_link
      t.boolean :is_accepted, default: false
    end
  end
end
