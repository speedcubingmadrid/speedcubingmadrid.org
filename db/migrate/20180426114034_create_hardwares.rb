class CreateHardwares < ActiveRecord::Migration[5.1]
  def change
    create_table :bags do |t|
      t.string :name, null: false

      t.timestamps
    end

    create_table :hardwares do |t|
      t.string :name, null: false
      t.string :hardware_type, null: false
      t.string :comment
      t.string :state, null: false
      t.references :bag

      t.timestamps
    end

    create_table :owners do |t|
      t.references :item, polymorphic: true, index: true, null: false
      t.integer :user_id, null: false
      t.date :start, null: false
      t.date :end, null: false
    end
  end
end
