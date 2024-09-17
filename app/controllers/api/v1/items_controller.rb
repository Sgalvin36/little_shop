class Api::V1::ItemsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :not_complete_response

    def index
      @items = if params[:sorted]
                Item.sorted_by_price
              else
                Item.all
              end
      render json: ItemSerializer.new(@items)
    end

    def show
      item = Item.find(params[:id])
      render json: ItemSerializer.new(item)
    end

    def create
        new_item = Item.create!(item_params)
        render json: ItemSerializer.new(new_item), status: 201
    end

    def update
        update_item = Item.find(params[:id])
        update_item.update!(item_params)
        render json: ItemSerializer.new(update_item)
    end

    def destroy
        render json: Item.destroy(params[:id]), status: 204
    end

    def find
      items = Item.filter_params(params)
  
      render json: ItemSerializer.new(items)
    end
    
    private

    def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end

    def not_found_response(exception)
        render json: ErrorSerializer.serialize(exception, "404"), status: :not_found
    end

    def not_complete_response(exception)
        if exception.message.include?('Merchant')
            render json: ErrorSerializer.serialize(exception, "400"), status: :bad_request
        else
            render json: ErrorSerializer.serialize(exception, "422"), status: :unprocessable_entity
        end
    end
end

