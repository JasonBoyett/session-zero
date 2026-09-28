class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.timestamps
      t.string :name, null: false
      t.string :system, default: "Dungeons and Dragons 5e"
      t.text :description
      t.boolean :is_session_zero_complete, default: false

      t.references :game_master_profile, null: false, foreign_key: true
    end
  end
end
