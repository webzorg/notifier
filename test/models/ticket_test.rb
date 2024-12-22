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

  test "status enum scopes" do
    tickets_count = 10
    tickets_pending_count = 4
    tickets_done_count = tickets_count - tickets_pending_count

    tickets = create_list(:ticket, tickets_count)
    tickets.sample(tickets_count - tickets_pending_count).each { _1.update(status: :done) }

    assert_equal tickets_pending_count, Ticket.pending.count
    assert_equal tickets_done_count, Ticket.done.count
  end
end
