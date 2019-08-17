class AddBoardAndSoftwareToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :board, :boolean, default: false
    add_column :users, :software, :boolean, default: false
  end
end
