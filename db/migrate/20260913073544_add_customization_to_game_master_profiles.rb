class AddCustomizationToGameMasterProfiles < ActiveRecord::Migration[8.1]
  def up
    add_column :game_master_profiles, :name, :string
    add_column :game_master_profiles, :profile_picture, :string
    add_column :game_master_profiles, :bio, :text
    add_column :game_master_profiles, :systems, :json, null: false, default: []
    add_column :game_master_profiles, :last_used_at, :datetime

    execute <<~SQL
      UPDATE game_master_profiles
      SET last_used_at = created_at
      WHERE last_used_at IS NULL
    SQL

    change_column_null :game_master_profiles, :last_used_at, false
    change_column_default :game_master_profiles,
      :last_used_at,
      from: nil,
      to: -> { "CURRENT_TIMESTAMP" }
  end

  def down
    remove_column :game_master_profiles, :name
    remove_column :game_master_profiles, :profile_picture
    remove_column :game_master_profiles, :bio
    remove_column :game_master_profiles, :systems
    remove_column :game_master_profiles, :last_used_at
  end
end
