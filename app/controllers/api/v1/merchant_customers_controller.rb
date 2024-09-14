class Api::V1::MerchantCustomersController < ApplicationController
    def index
        merchant = Merchant.find(params[:merchant_id])
        customers = merchant.customers.uniq
        render json: CustomerSerializer.new(customers)
    end
end
