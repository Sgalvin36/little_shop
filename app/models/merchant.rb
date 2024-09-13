class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices

    def self.sorted_by_created_at
        order(created_at: :desc)
    end
    def self.filter_by_status
        joins(:invoices).where("status = 'returned'")
    end
end