class Api::V1::MerchantInvoicesController < ApplicationController
    def index
        # binding.pry
        @invoices = Invoice.where("merchant_id = ?" , "#{params[:merchant_id]}") 
        if params[:status]
            @invoices = Invoice.where("status = ?", "#{params[:status]}")
        end
            
        render json: InvoiceSerializer.new(@invoices)
    end
end