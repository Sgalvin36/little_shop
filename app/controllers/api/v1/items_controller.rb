class Api::V1::ItemsController < ApplicationController
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