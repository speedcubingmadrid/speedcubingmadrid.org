class ModifySubscriptionParameters < ActiveRecord::Migration[5.1]
  def change
    remove_column :subscriptions, :firstname
    remove_column :subscriptions, :payed_at
    add_column :subscriptions, :amount, :integer
    rename_column :subscriptions, :receipt_url, :stripe_charge_id
    add_timestamps :subscriptions, null: false

    change_column_default(:users, :notify_subscription, from: false, to: true)
    User.where(notify_subscription: false).update_all(notify_subscription: true)
  end
end
