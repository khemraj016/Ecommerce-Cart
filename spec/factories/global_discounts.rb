FactoryGirl.define do
  factory :global_discount do
    cart_min_value "9.99"
    cart_max_value "9.99"
    additional_discount "9.99"
    status "MyString"
  end
end
