class Api::V1::MerchantsController < ApplicationController

    def index
        merchants = Merchant.all

        if params[:sorted]
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
        begin
            merchant = Merchant.find(params[:id])

            render json: MerchantSerializer.new(merchant)
        rescue ActiveRecord::RecordNotFound => exception
            render json: ErrorSerializer.serialize(exception, "404"), status: :not_found
        end
    end

    def create
        merchant = Merchant.create(merchant_params)
        
        if merchant.save
        render json: MerchantSerializer.new(merchant), status: 201
        else
            render json: { errors: merchant.errors.full_messages }, status: :bad_request       
        end
    end

    def update
       merchant = Merchant.find(params[:id])
       
       if merchant.update(merchant_params)
        render json: MerchantSerializer.new(merchant).serializable_hash.to_json
       else
        render json: {errors: merchant.errors.full_messages}, status: :bad_request
       end
    end

    def destroy
       merchant = Merchant.find(params[:id])
       merchant.destroy
       head :no_content
    end

    def find
        items = Item.filter_params(params)
    #     if params[:name].present?
    #         merchants = Merchant.where("name ILIKE ?", "%#{params[:name]}%").order(:name)
    #         if merchants.any?
    #             render json: MerchantSerializer.new(merchants.first)
    #         else
    #             render json: { error: 'Merchant not found' }, status: :not_found
    #         end
    #     else
    #         render json: { error: 'Name parameter cannot be empty' }, status: :bad_request
    #     end
    # end

private

    def merchant_params
        params.require(:merchant).permit(:name)
    end

end