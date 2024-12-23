class User < ApplicationRecord
  has_many :tickets

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, email: true, length: { maximum: 255 }
  validates :due_date_reminder_offset_in_days, inclusion: { in: 0.., message: :must_be_positive_integer }
  validates :time_zone, timezone: true

  def due_date_reminder_time_with_time_zone
    due_date_reminder_time.change(zone: time_zone)
  end

  # whenever extended, can you loaded from user settings table or similar
  def reminder_delivery_methods
    DueDateReminder::DispatcherJob::DELIVERY_METHODS & %i[email]
  end
end
