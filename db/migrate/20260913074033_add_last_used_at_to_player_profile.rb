class AddLastUsedAtToPlayerProfile < ActiveRecord::Migration[8.1]
  def up
    add_column :player_profiles, :last_used_at, :datetime

    execute <<~SQL
      UPDATE player_profiles
      SET last_used_at = created_at
      WHERE last_used_at IS NULL
    SQL

    change_column_null :player_profiles, :last_used_at, false
    change_column_default :player_profiles,
      :last_used_at,
      from: nil,
      to: -> { "CURRENT_TIMESTAMP" }
  end

  def down
    remove_column :player_profiles, :last_used_at
  end
end
