class AddNotifySubscriptionToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :notify_subscription, :boolean, default: false
  end
end
