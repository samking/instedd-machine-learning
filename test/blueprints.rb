require 'machinist/active_record'
require 'sham'

Sham.define do 
  uid { Faker::Internet.user_name }
end

def random_sized_name (length)
  (1..length).map { ('a'..'z').to_a.rand }
end

Dataset.blueprint do
  uid
end

Dataset.blueprint :uid_short do
  uid { random_sized_name 2 }
end

Dataset.blueprint :uid_test do
  uid { "test" }
end

