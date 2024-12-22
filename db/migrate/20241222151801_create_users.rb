class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.boolean :due_date_reminder_enabled, null: false, default: true
      t.integer :due_date_reminder_offset_in_days, null: false, default: 0
      t.time :due_date_reminder_time, null: false, default: "07:00:00"
      t.string :time_zone, limit: 30, null: false, default: "UTC"

      t.timestamps
    end
  end
end
