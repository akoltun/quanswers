class ConvertRemarkToPolymorphic < ActiveRecord::Migration
  def change
    remove_index :remarks, :question_id
    rename_column :remarks, :question_id, :remarkable_id
    add_column :remarks, :remarkable_type, :string
    add_index :remarks, [:remarkable_type, :remarkable_id]
  end
end
