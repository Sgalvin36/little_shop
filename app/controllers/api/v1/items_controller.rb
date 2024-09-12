class Api::V1::ItemsController < ApplicationController
    def index
      @items = if params[:sort] == 'unit_price'
                Item.sorted_by_price
              else
                Item.all
              end

      render json: ItemSerializer.new(@items).serializable_hash.to_json
    end

    def show
      item = Item.find(params[:id])
      render json: ItemSerializer.new(item)
    end

    def create
        render json: Item.create(item_params)
    end

    def update
        update_item = Item.find(params[:id])
        render json: update_item.update(item_params)
    end

    private

    def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end

