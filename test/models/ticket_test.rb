require "test_helper"

class TicketTest < ActiveSupport::TestCase
  test "title can't be blank" do
    ticket = build(:ticket, title: "")
    ticket.valid?

    assert_equal "can't be blank", ticket.errors[:title].first
  end

  test "title can't be longer than 255 characters" do
    ticket = build(:ticket, title: "a"*256)
    ticket.valid?

    assert_equal "is too long (maximum is 255 characters)", ticket.errors[:title].first
  end

  test "progress should be within 0 and 100" do
    ticket = build(:ticket, progress: [-1, nil, 101].sample)
    ticket.valid?

    assert_equal I18n.t("activerecord.errors.messages.must_be_within_0_to_100"), ticket.errors[:progress].first
  end

  test "due_date can't be blank" do
    ticket = build(:ticket, due_date: nil)
    ticket.valid?

    assert_equal "can't be blank", ticket.errors[:due_date].first
  end

  test "status can't be blank or invalid" do
    ticket = build(:ticket, status: nil)
    ticket.valid?

    assert_equal "can't be blank", ticket.errors[:status].first

    assert_raise(ArgumentError) do
      ticket.status = :non_existing_enum_mapping
    end
  end

  test "due_date must be in the future" do
    ticket = build(:ticket, due_date: Date.today)

    assert ticket.valid?

    ticket.due_date = Date.yesterday

    assert ticket.invalid?
    assert_equal I18n.t("activerecord.errors.messages.must_be_today_or_in_future"), ticket.errors[:due_date].first
  end



  test "status enum scopes" do
    tickets_count = 10
    tickets_pending_count = 4
    tickets_done_count = tickets_count - tickets_pending_count

    tickets = create_list(:ticket, tickets_count)
    tickets.sample(tickets_count - tickets_pending_count).each { _1.update(status: :done) }

    assert_equal tickets_pending_count, Ticket.pending.count
    assert_equal tickets_done_count, Ticket.done.count
  end

  test ".active scope to correctly handle pending scope and progress" do
    tickets = create_list(:ticket, 3)

    assert_equal tickets.count, Ticket.active.count

    tickets.first.update(status: :done)
    tickets.second.update(progress: 100)

    assert 1, Ticket.active.count
  end

  test "#active? to return expected boolean" do
    ticket = create(:ticket)

    assert ticket.active?

    ticket.update(status: :done)

    assert_not ticket.active?

    ticket.update(status: :pending, progress: 100)

    assert_not ticket.active?
  end

  test "#expected_reminder_delivery_time to return expected reminder delivery time" do
    user = build(:user, due_date_reminder_offset_in_days: 5, due_date_reminder_time: "9:45", time_zone: "Europe/Vienna")
    ticket = build(:ticket, user:, due_date: "2020-12-25")

    expected_delivery_at = ticket.expected_reminder_delivery_time

    assert_equal 2020, expected_delivery_at.year
    assert_equal 12, expected_delivery_at.month
    assert_equal 20, expected_delivery_at.day
    assert_equal 9, expected_delivery_at.hour
    assert_equal 45, expected_delivery_at.min
    assert_equal "Europe/Vienna", expected_delivery_at.time_zone.name
  end
end
