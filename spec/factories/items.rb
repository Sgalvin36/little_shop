require 'faker'
FactoryBot.define do
  factory :item do
    name { Faker::Fantasy::Tolkien.character }
    description { Faker::Fantasy::Tolkien.poem }
    unit_price { Faker::Number.decimal(l_digits:2) }
    merchant_id { "" }
  end
end
