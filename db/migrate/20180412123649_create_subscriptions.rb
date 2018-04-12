class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user
      t.string :name
      t.string :firstname
      t.string :wca_id
      t.string :email
      t.datetime :payed_at
      t.string :receipt_url
    end
    add_index :subscriptions, :wca_id
  end
end
