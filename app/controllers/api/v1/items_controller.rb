class Api::V1::ItemsController < ApplicationController
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
        new_item = Item.create(item_params)
        render json: ItemSerializer.new(new_item), status: 201
    end

    def update
        update_item = Item.find(params[:id])
        update_item.update(item_params)
        render json: ItemSerializer.new(update_item)
    end

    def destroy
        render json: Item.destroy(params[:id]), status: 204
    end

    def find
      items = Item.filter_params(params)
  
      render json: ItemSerializer.new(items)
        
      #     render json: { error: 'Items not found' }, status: :not_found
      #   end
      # else
      #   render json: { error: 'Name parameter cannot be empty' }, status: :bad_request
      # end
    end
    
    private

    def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end

