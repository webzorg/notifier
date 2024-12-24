class Ticket < ApplicationRecord
  belongs_to :user

  enum :status, pending: 0, done: 1

  validates :title, presence: true, length: { maximum: 255 }
  validates :progress, inclusion: { in: 0..100, message: :must_be_within_0_to_100 }
  validates :status, presence: true
  validates :due_date, presence: true, date: { today_or_future: true }

  scope :active, -> { pending.where.not(progress: 100) }

  def expected_reminder_delivery_time
    user.due_date_reminder_time.change(
      year: due_date.year,
      month: due_date.month,
      day: due_date.day - user.due_date_reminder_offset_in_days,
      zone: user.time_zone
    )
  end

  def active?
    Ticket.active.exists?(id:)
  end
end
