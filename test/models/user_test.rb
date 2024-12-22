require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "name can't be blank" do
    user = User.new(name: "", email: "valid-email@test.com")
    user.valid?

    assert_equal "can't be blank", user.errors[:name].first
  end

  test "name can't be longer than 255 characters" do
    user = User.new(name: "a"*256, email: "valid-email@test.com")
    user.valid?

    assert_equal "is too long (maximum is 255 characters)", user.errors[:name].first
  end

  test "email can't be blank" do
    user = User.new(name: "valid name", email: "")
    user.valid?

    assert_equal "can't be blank", user.errors[:email].first
  end

  test "email can't be longer than 255 characters" do
    user = User.new(name: "valid name", email: "#{'a'*256}@test.com")
    user.valid?

    assert_equal "is too long (maximum is 255 characters)", user.errors[:email].first
  end

  test "email must be of valid format" do
    user = User.new(name: "valid name", email: "invalid-email@test")
    user.valid?

    assert_equal I18n.t("activerecord.errors.messages.invalid_format"), user.errors[:email].first
  end

  test "due_date_reminder_enabled to be boolean and have default" do
    user = User.new(name: "valid name", email: "valid-email@test.com")

    assert user.due_date_reminder_enabled

    user.toggle(:due_date_reminder_enabled)

    assert_not user.due_date_reminder_enabled
  end

  test "due_date_reminder_offset_in_days to only allow positive integers" do
    user = User.new(name: "valid name", email: "valid-email@test.com", due_date_reminder_offset_in_days: -1)
    user.valid?

    assert_equal I18n.t("activerecord.errors.messages.must_be_positive_integer"),
                 user.errors[:due_date_reminder_offset_in_days].first
  end

  test "due_date_reminder_offset_in_days to have default" do
    user = User.new(name: "valid name", email: "valid-email@test.com")

    assert_equal 0, user.due_date_reminder_offset_in_days
  end

  test "due_date_reminder_time to be of type time and to have default" do
    user = User.new(name: "valid name", email: "valid-email@test.com")

    assert_equal Time.new(2000, 1, 1, 7, 0, 0, "+00:00"), user.due_date_reminder_time

    user.due_date_reminder_time = Time.new(2050, 1, 1, 8, 0, 0, "+00:00")

    assert_equal Time.new(2000, 1, 1, 8, 0, 0, "+00:00"), user.due_date_reminder_time
  end

  test "time_zone to be of type time and to have default" do
    user = User.new(name: "valid name", email: "valid-email@test.com")

    assert_equal "UTC", user.time_zone

    user.time_zone = "Europe/Vienna"

    assert user.valid?

    user.time_zone = "invalid time zone"

    assert user.invalid?
    assert_equal I18n.t("activerecord.errors.messages.invalid_format"), user.errors[:time_zone].first
  end

  test "#due_date_reminder_time_with_time_zone to return due_date_reminder_time with user set time_zone" do
    user = User.new(name: "valid name", email: "valid-email@test.com", time_zone: "Europe/Vienna")

    assert_equal "Europe/Vienna", user.due_date_reminder_time_with_time_zone.time_zone.name
  end
end
