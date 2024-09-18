class Api::V1::MerchantInvoicesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
    
    def index
        Merchant.find(params[:merchant_id])
        @invoices = Invoice.where("merchant_id = ?" , "#{params[:merchant_id]}") 
        if params[:status]
            @invoices = @invoices.where("status = ?", "#{params[:status]}")
        end
        render json: InvoiceSerializer.new(@invoices)
    end

    def not_found_response(exception)
        render json: ErrorSerializer.serialize(exception, "404"), status: :not_found
    end
end