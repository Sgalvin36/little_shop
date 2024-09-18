class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy

  validates :unit_price, presence: true
  validates :unit_price, numericality: true
  def self.sorted_by_price
    order(unit_price: :asc)
  end

  def self.param_check(params)
    if params.include?(:name) && (params.include?(:min_price) || params.include?(:max_price))
      "Cannot send name and price together"
    elsif params.include?(:min_price) && params[:min_price].to_i < 0
      "Minimum price needs to be greater than 0"
    elsif params.include?(:max_price) && params[:max_price].to_i < 0
      "Maximum price needs to be greater than 0"
    elsif params.include?(:name) && params[:name] == ""
      "Name query cannot be blank"
    else
      4
    end
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