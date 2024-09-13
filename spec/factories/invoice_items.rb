FactoryBot.define do
  factory :invoice_item do
    item_id { "" }
    invoice_id { "" }
    quantity { Faker::Number.number }
    unit_price { Faker::Number.decimal(l_digits:2) }
  end
end
