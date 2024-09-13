class Api::V1::MerchantsController < ApplicationController

    def index
        merchants = Merchant.all

        if params[:sort]
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
        render json: Merchant.create(merchant_params)
    end

    private

    def merchant_params
        params.require(:merchant).permit(:name)
    end

end