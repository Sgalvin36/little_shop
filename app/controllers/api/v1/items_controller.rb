class Api::V1::ItemsController < ApplicationController
  def index
    @items = Item.all
    render json: ItemSerializer.new(@items).serializable_hash.to_json
  end

end
