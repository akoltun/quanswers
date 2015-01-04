class CreateRemarks < ActiveRecord::Migration
  def change
    create_table :remarks do |t|
      t.references :user, index: true
      t.references :question, index: true
      t.text :remark

      t.timestamps
    end
  end
end
