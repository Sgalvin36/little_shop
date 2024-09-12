class Api::V1::MerchantInvoicesController < ApplicationController
    def index
        # binding.pry 
      @invoices = Invoice.where("merchant_id = #{params[:merchant_id]}")
      render json: InvoiceSerializer.new(@invoices)
    end
end