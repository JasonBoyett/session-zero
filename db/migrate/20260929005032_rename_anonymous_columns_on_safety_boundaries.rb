class RenameAnonymousColumnsOnSafetyBoundaries < ActiveRecord::Migration[8.1]
  def change
    rename_column :lines, :is_annonymous, :is_anonymous
    rename_column :veils, :is_annonymous, :is_anonymous
  end
end
