class CreateCompetitionGalleries < ActiveRecord::Migration[5.2]
  def change
    create_table :competition_galleries do |t|
      t.string :competition_id
      t.integer :user_id
      t.boolean :draft, null: false, default: true
      t.boolean :feature, null: false, default: false

      t.timestamps
    end
  end
end
