class Item < ApplicationRecord
  belongs_to :merchant

  def self.sorted_by_price
    order(unit_price: :asc)
  end

end