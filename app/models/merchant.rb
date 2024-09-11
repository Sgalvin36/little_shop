class Merchant < ApplicationRecord
  has_many :items

    def self.sorted_by_created_at
        order(created_at: :desc)
    end
end