class DueDateReminderMailer < ApplicationMailer
  def notify
    @ticket = params.fetch(:ticket)

    days_count = @ticket.user.due_date_reminder_offset_in_days
    @days_left_text = days_count.zero? ? "today" : "in #{days_count} days"

    mail to: @ticket.user.email
  end
end
