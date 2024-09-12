class Api::V1::MerchantInvoicesController < ApplicationController
    def index
      @invoices = Invoice[merchant_id: params[:id]].all
      render json: ItemSerializer.new(@invoices)
    end