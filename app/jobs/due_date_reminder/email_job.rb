class DueDateReminder::EmailJob < ApplicationJob
  def perform(ticket_id)
    ticket = Ticket.includes(:user).find(ticket_id)

    DueDateReminderMailer.with(ticket:).notify.deliver_now
  end
end
