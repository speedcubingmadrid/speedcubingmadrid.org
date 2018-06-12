class DropCompetitionsRequest < ActiveRecord::Migration[5.1]
  def change
    drop_table :competitions_requests do |t|
      t.datetime :succeed_at
      t.integer :user_id
    end
  end
end
