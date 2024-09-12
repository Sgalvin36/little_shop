class Api::V1::MerchantInvoicesController < ApplicationController
    def index
        binding.pry
      @invoices = Invoice[merchant_id: params[:id]].all
      render json: InvoiceSerializer.new(@invoices)
    end
end