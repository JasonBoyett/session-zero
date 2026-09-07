class CreatePlayerNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :player_notes do |t|
      t.string :name
      t.string :content
      t.boolean :is_public
      t.boolean :is_annonymous, default: false, null: false

      t.timestamps

      t.refereces :player_profile, null: false, foreign_key: true
    end
  end
end
