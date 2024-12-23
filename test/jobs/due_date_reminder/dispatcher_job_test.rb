require "test_helper"

class DueDateReminder::DispatcherJobTest < ActiveJob::TestCase
  test "enqueue EmailJobs based on which user has reminders enabled" do
    tickets_count = 10
    tickets_with_user_due_date_reminder_enabled = 6
    tickets_with_user_due_date_reminder_disabled = tickets_count - tickets_with_user_due_date_reminder_enabled

    tickets = create_list(:ticket, tickets_count, due_date: Date.today)
    tickets.sample(tickets_with_user_due_date_reminder_disabled).each do |ticket|
      ticket.user.update(due_date_reminder_enabled: false)
    end

    assert_enqueued_jobs tickets_with_user_due_date_reminder_enabled, only: DueDateReminder::EmailJob do
      DueDateReminder::DispatcherJob.perform_now
    end

    Ticket.includes(:user).pending.where(user: { due_date_reminder_enabled: true }).each do |ticket|
      assert_enqueued_with(job: DueDateReminder::EmailJob, args: [ticket.id])
    end
  end
end
