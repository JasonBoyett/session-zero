class CreateGameMasterNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :game_master_notes do |t|
      t.string :name
      t.text :content
      t.boolean :is_public, default: false, null: false

      t.timestamps

      t.references :game, null: false, foreign_key: true
    end
  end
end
