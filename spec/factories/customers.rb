FactoryBot.define do
  factory :customer do
    first_name { Faker::Fantasy::Tolkien.character }
    last_name { Faker::Fantasy::Tolkien.race }
  end
end
