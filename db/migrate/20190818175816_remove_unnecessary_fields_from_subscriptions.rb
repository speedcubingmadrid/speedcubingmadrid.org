class RemoveUnnecessaryFieldsFromSubscriptions < ActiveRecord::Migration[5.2]
  def change
    remove_index "wca_id", name: "index_subscriptions_on_wca_id"

    remove_column :subscriptions, :name
    remove_column :subscriptions, :wca_id
    remove_column :subscriptions, :email
  end
end
