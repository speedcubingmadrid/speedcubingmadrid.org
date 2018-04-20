class CreateMajorComps < ActiveRecord::Migration[5.1]
  def change
    create_table :major_comps do |t|
      t.string :competition_id
      t.string :role
      t.string :name
      t.text :alt_text
      t.index :role, unique: true
    end
  end
end
