FactoryBot.define do
  factory :merchant do
    name { Faker::Movies::Starwars.character }
  end
end
