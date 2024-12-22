class Ticket < ApplicationRecord
  belongs_to :user

  enum :status, pending: 0, done: 1

  validates :title, presence: true, length: { maximum: 255 }
  validates :progress, inclusion: { in: 0..100, message: :must_be_within_0_to_100 }
  validates :status, presence: true
  validates :due_date, presence: true
end
