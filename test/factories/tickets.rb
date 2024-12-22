FactoryBot.define do
  factory :ticket do
      user
      title { Faker::Lorem.sentence }
      description { Faker::Lorem.paragraph_by_chars(number: 1024) }
      due_date { 7.days.from_now.to_date }
      status { :pending }
      progress { 0 }
  end
end
