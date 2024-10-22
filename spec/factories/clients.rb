# spec/factories/clients.rb
FactoryBot.define do
  factory :client do
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
