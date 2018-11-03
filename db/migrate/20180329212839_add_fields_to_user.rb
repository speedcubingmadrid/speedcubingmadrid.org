class AddFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :delegate_status, :string
    add_column :users, :admin, :boolean, default: false
    add_column :users, :communication, :boolean, default: false
    add_column :users, :spanish_delegate, :boolean, default: false
  end
end
