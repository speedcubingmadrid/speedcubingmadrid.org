class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false, default: ""
      t.text :body
      t.string :slug, null: false
      t.boolean :feature, null: false, default: false
      t.references :user, null: false
      t.boolean :draft, null: false, default: true
      t.boolean :competition_page, null: false, default: false

      t.timestamps
    end
    add_index(:posts, :slug)
  end
end
