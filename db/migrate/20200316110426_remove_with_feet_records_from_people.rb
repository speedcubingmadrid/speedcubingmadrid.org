class RemoveWithFeetRecordsFromPeople < ActiveRecord::Migration[5.2]
  def change
    remove_column :people, :s_333ft
    remove_column :people, :a_333ft
  end
end
