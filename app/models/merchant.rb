class Merchant < ApplicationRecord
    def self.sorted_by_created_at
        order(created_at: :desc)
    end
end