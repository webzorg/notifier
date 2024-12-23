require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "name can't be blank" do
    user = build(:user, name: "")
    user.valid?

    assert_equal "can't be blank", user.errors[:name].first
  end

  test "name can't be longer than 255 characters" do
    user = build(:user, name: "a" * 256)
    user.valid?

    assert_equal "is too long (maximum is 255 characters)", user.errors[:name].first
  end

  test "email can't be blank" do
    user = build(:user, email: "")
    user.valid?

    assert_equal "can't be blank", user.errors[:email].first
  end

  test "email can't be longer than 255 characters" do
    user =build(:user, email: "#{'a'*256}@test.com")
    user.valid?

    assert_equal "is too long (maximum is 255 characters)", user.errors[:email].first
  end

  test "email must be of valid format" do
    user = build(:user, email: "invalid-email@test")
    user.valid?

    assert_equal I18n.t("activerecord.errors.messages.invalid_format"), user.errors[:email].first
  end

  test "due_date_reminder_enabled to be boolean and have default" do
    user = build(:user)

    assert user.due_date_reminder_enabled

    user.toggle(:due_date_reminder_enabled)

    assert_not user.due_date_reminder_enabled
  end

  test "due_date_reminder_offset_in_days to only allow positive integers" do
    user = build(:user, due_date_reminder_offset_in_days: -1)
    user.valid?

    assert_equal I18n.t("activerecord.errors.messages.must_be_positive_integer"),
                 user.errors[:due_date_reminder_offset_in_days].first
  end

  test "due_date_reminder_offset_in_days to have default" do
    user = build(:user)

    assert_equal 0, user.due_date_reminder_offset_in_days
  end

  test "due_date_reminder_time to be of type time and to have default" do
    user = build(:user)

    assert_equal Time.new(2000, 1, 1, 7, 0, 0, "+00:00"), user.due_date_reminder_time

    user.due_date_reminder_time = Time.new(2050, 1, 1, 8, 0, 0, "+00:00")

    assert_equal Time.new(2000, 1, 1, 8, 0, 0, "+00:00"), user.due_date_reminder_time
  end

  test "time_zone to be of type time and to have default" do
    user = build(:user)

    assert_equal "UTC", user.time_zone

    user.time_zone = "Europe/Vienna"

    assert user.valid?

    user.time_zone = "invalid time zone"

    assert user.invalid?
    assert_equal I18n.t("activerecord.errors.messages.invalid_format"),
                 user.errors[:time_zone].first
  end

  test "#reminder_delivery_methods returns array containing email delivery method" do
    user = build(:user, time_zone: "Europe/Vienna")

    assert_equal %i[email], user.reminder_delivery_methods
  end
end
