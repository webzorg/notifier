# Preview all emails at http://localhost:3000/rails/mailers/due_date_reminder_mailer
class DueDateReminderMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/due_date_reminder_mailer/notify
  def notify
    ticket = Ticket.new(
      id: 123,
      title: "Some Task",
      user: User.new(name: "preview user", email: "test@preview.com", due_date_reminder_offset_in_days: 2)
    )

    DueDateReminderMailer.with(ticket: ticket).notify
  end
end
