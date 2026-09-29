class AlignGamesWithGameMasterProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :games, :system, :string, default: "Dungeons and Dragons 5e"
    add_column :games, :is_session_zero_complete, :boolean, default: false

    remove_column :games, :game_master_id, :string if column_exists?(:games, :game_master_id)

    add_reference :games,
      :game_master_profile,
      null: false,
      foreign_key: true
  end
end
