class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :color
      t.string :fullname
      t.index :name, unique: true
    end

    create_table :post_tags do |t|
      t.references :post, null: false
      t.string :tag_name, null: false
      t.index :tag_name
      t.index [:tag_name, :post_id], unique: true
    end
  end
end
