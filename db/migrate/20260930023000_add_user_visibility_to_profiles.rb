class AddUserVisibilityToProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :game_master_profiles, :is_user_public, :boolean, default: false, null: false
    add_column :player_profiles, :is_user_public, :boolean, default: false, null: false
  end
end
