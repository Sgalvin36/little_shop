class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy

  def self.sorted_by_price
    order(unit_price: :asc)
  end

  def self.filter_params(params)
    if params.include?(:max_price) && params.include?(:min_price)
      min_price = params[:min_price]
      max_price = params [:max_price]
      where("unit_price >= ? AND unit_price <= ?", min_price, max_price)
      # do function for searching both parameters
    elsif params.include?(:max_price)
      max_price = params[:max_price]
      where("unit_price <= ?", max_price)
      # do function for searching max price
    elsif params.include?(:min_price)
      min_price = params[:min_price]
      where("unit_price >= ?", min_price)
      # do function for searching min price
    elsif params.include?(:name)
      name = params[:name]
      where("name ILIKE?", "%#{name}%")
      
    else
      return all
    end
  end

end