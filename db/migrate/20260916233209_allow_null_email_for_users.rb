class AllowNullEmailForUsers < ActiveRecord::Migration[8.1]
  def up
    change_column_null :users, :email, true
    change_column_default :users, :email, from: "", to: nil

    execute <<~SQL
      UPDATE users
      SET email = NULL
      WHERE email = ''
    SQL
  end

  def down
    if select_value("SELECT COUNT(*) FROM users WHERE email IS NULL").positive?
      raise ActiveRecord::IrreversibleMigration,
        "Cannot require email while users with null emails exist"
    end

    change_column_default :users, :email, from: nil, to: ""
    change_column_null :users, :email, false
  end
end
