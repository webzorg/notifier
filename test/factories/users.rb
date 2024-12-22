FactoryBot.define do
  factory :user do
      name { Faker::Name.name }
      email { Faker::Internet.email }
      due_date_reminder_enabled { true }
      due_date_reminder_offset_in_days { 0 }
      due_date_reminder_time { "7:00" }
      time_zone { "UTC" }
  end
end
