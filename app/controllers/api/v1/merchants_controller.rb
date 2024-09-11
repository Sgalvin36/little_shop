class Api::V1::MerchantsController < ApplicationController

    def index
        merchants = Merchant.all
        render json: MerchantSerializer.new(merchants).serializable_hash.to_json
    end

    def create
        render json: Merchant.create(merchant_params)
    end

    private

    def merchant_params
        params.require(:merchant).permit(:name)
    end

end