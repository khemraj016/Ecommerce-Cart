FactoryGirl.define do
  factory :discount do
    name Faker::Lorem.word
    price 75
    total_quantity 3
  end
end
