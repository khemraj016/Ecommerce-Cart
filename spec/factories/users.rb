FactoryGirl.define do
  factory :user do
    email { "#{Faker::Name.first_name}@example.com" }
    password { Faker::Lorem.sentence }
    guest true
  end
end
