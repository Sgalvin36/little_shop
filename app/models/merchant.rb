class Merchant < ApplicationRecord
  has_many :items 
  has_many :invoices

    def self.sorted_by_created_at
        order(created_at: :desc)
    end
end