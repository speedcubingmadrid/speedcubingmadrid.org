class CreateCompetitions < ActiveRecord::Migration[5.1]
  def change
    create_table :competitions, id: false do |t|
      t.string :id, unique: true, null: false
      t.string :name
      t.string :city
      t.date :start_date
      t.date :end_date
      t.string :country_iso2
      t.string :website
      t.string :delegates
      t.string :organizers
      t.index :id, unique: true
    end

    create_table :competitions_requests do |t|
      t.datetime :succeed_at
      t.integer :user_id
    end
  end
end
