require "test_helper"

class ReminderEmailDeliveryTest < ActionDispatch::IntegrationTest
  test "ticket due date reminder is sent if due_date is today" do
    ticket = create(:ticket, due_date: Date.today)

    DueDateReminder::DispatcherJob.perform_now

    assert_enqueued_with(job: DueDateReminder::EmailJob, args: [ticket.id])

    perform_enqueued_jobs

    assert_equal 1, ActionMailer::Base.deliveries.count
  end

  test "ticket due date reminder is not sent if due_date is not today" do
    create(:ticket, due_date: Date.tomorrow)

    assert_no_enqueued_jobs do
      DueDateReminder::DispatcherJob.perform_now
    end

    perform_enqueued_jobs

    assert_empty ActionMailer::Base.deliveries
  end

  test "ticket due date reminder email is scheduled exactactly at a user defined time" do
    expected_delivery_date = 2.days.from_now.to_date
    user = build(:user, due_date_reminder_offset_in_days: 1, due_date_reminder_time: "9:30", time_zone: "Europe/Vienna")
    ticket = create(:ticket, user:, due_date: expected_delivery_date)

    assert_no_enqueued_jobs do
      DueDateReminder::DispatcherJob.perform_now
    end

    travel_to 1.day.from_now.change(hour: 9, min: 30, zone: "Europe/Vienna")

    assert_enqueued_with(job: DueDateReminder::EmailJob, args: [ticket.id]) do
      DueDateReminder::DispatcherJob.perform_now
    end

    assert_equal Time.current, DateTime.parse(enqueued_jobs.first["scheduled_at"])
  end
end
