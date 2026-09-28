class CreateGameMasterProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :game_master_profiles do |t|
      t.timestamps

      t.references :user, null: false, foreign_key: true
    end
  end
end
