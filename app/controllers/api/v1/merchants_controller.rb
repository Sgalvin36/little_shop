class Api::V1::MerchantsController < ApplicationController

    def index
        merchants = Merchant.all

        if params[:sort]
            merchants = merchants.sorted_by_created_at
        elsif params[:status]
            merchants = merchants.filter_by_status
        end

        render json: MerchantSerializer.new(merchants)
    end

    def show
        merchant = Merchant.find(params[:id])

        render json: MerchantSerializer.new(merchant)
    end

    def create
        render json: Merchant.create(merchant_params)
    end

    def update
        update_merchant = Merchant.find(params[:id])
        update_merchant.update(merchant_params)
        render json: MerchantSerializer.new(update_merchant).serializable_hash.to_json
      end

    private

    def merchant_params
        params.require(:merchant).permit(:name)
    end

end