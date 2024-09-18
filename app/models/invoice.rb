class Invoice < ApplicationRecord
    belongs_to :merchant
    belongs_to :customer

    # def self.index_controller(params)
    #     if Merchant.find(params[:merchant_id])
    #         @invoices = Invoice.where("merchant_id = ?" , "#{params[:merchant_id]}") 
    #         if params[:status]
    #             @invoices = @invoices.where("status = ?", "#{params[:status]}")
    #         end
    #     else
    #         false
    #     end
    # end
end