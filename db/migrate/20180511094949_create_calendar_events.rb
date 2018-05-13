class CreateCalendarEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :calendar_events do |t|
      t.string :name
      t.boolean :public
      t.datetime :start_time
      t.datetime :end_time
      t.string :kind

      t.timestamps
    end
  end
end
