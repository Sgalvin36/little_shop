class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy 
  has_many :invoices, dependent: :destroy
  has_many :customers, through: :invoices, source: :customer
  validates :name, presence: true

    def self.sorted_by_created_at
        order(created_at: :desc)
    end

    def self.filter_by_status
        joins(:invoices).where("status = 'returned'")
    end

    def item_count
        items.count
    end
end