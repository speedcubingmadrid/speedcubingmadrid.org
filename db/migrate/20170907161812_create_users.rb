class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :wca_id
      t.string :country_iso2
      t.string :email
      t.string :avatar_url
      t.string :avatar_thumb_url
      t.string :gender
      t.date :birthdate

      t.timestamps
    end
  end
end
