class CreateLines < ActiveRecord::Migration[8.1]
  def change
    create_table :lines do |t|
      t.timestamps
    end
  end
end
