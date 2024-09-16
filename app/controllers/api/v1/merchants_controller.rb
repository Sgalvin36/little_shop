class Api::V1::MerchantsController < ApplicationController

    def index
        merchants = Merchant.all

        if params[:sorted]
            merchants = merchants.sorted_by_created_at
            render json: MerchantSerializer.new(merchants)
        elsif params[:status]
            merchants = merchants.filter_by_status
            render json: MerchantSerializer.new(merchants)
        elsif params[:count]
            render json: MerchantItemSerializer.serialize(merchants)
        else
            render json: MerchantSerializer.new(merchants)
        end
    end

    def show
        merchant = Merchant.find(params[:id])

        render json: MerchantSerializer.new(merchant)
    end

    def create
        new_merchant = Merchant.create(merchant_params)
        render json: MerchantSerializer.new(new_merchant), status: 201
    end

    def update
        update_merchant = Merchant.find(params[:id])
        update_merchant.update(merchant_params)
        render json: MerchantSerializer.new(update_merchant).serializable_hash.to_json
      end

    def destroy
       merchant = Merchant.find(params[:id])
       merchant.destroy
       head :no_content
    end

private

    def merchant_params
        params.require(:merchant).permit(:name)
    end

end