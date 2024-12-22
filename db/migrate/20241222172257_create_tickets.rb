class CreateTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :tickets do |t|
      t.string :title, null: false
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.date :due_date, null: false
      t.integer :status, null: false, default: 0
      t.integer :progress, null: false, default: 0

      t.timestamps
    end
  end
end
