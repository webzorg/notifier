require "test_helper"

class DueDateReminderMailerTest < ActionMailer::TestCase
  test "notify" do
    ticket = create(:ticket)
    mail = DueDateReminderMailer.with(ticket:).notify

    assert_equal I18n.t("due_date_reminder_mailer.notify.subject"), mail.subject
    assert_equal [ticket.user.email], mail.to
    assert_equal [ApplicationMailer.default[:from]], mail.from
    assert_match "Ticket in question is due today", mail.body.encoded
  end

  test "notify with non-default user.due_date_reminder_offset_in_days" do
    ticket = create(:ticket, user: create(:user, due_date_reminder_offset_in_days: 10))

    mail = DueDateReminderMailer.with(ticket:).notify

    assert_match "Ticket in question is due in 10 days", mail.body.encoded
  end
end
