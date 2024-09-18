class Api::V1::MerchantsController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :not_complete_response
    rescue_from ActionController::ParameterMissing, with: :not_found_response

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
        begin
            merchant = Merchant.create!(merchant_params)
            render json: MerchantSerializer.new(merchant), status: :created
        rescue ActiveRecord::RecordInvalid => exception
            render json: ErrorSerializer.serialize(exception, "400"), status: :bad_request
        end
    end

    def update
        merchant = Merchant.find(params[:id])
        merchant.update!(merchant_params)
        render json: MerchantSerializer.new(merchant)
        # if merchant.update(merchant_params)
        #     render json: MerchantSerializer.new(merchant).serializable_hash.to_json
        # else
        #     render json: ErrorSerializer.serialize(merchant.errors, "400"), status: :bad_request
        # end
    end

    def destroy
        merchant = Merchant.find(params[:id])
        render json: merchant.destroy, status:204
        # head :no_content
    end

    def find
        if params[:name].present?
            merchants = Merchant.where("name ILIKE ?", "%#{params[:name]}%").order(:name)
            if merchants.any?
                render json: MerchantSerializer.new(merchants.first)
            else
                render json: { error: 'Merchant not found' }, status: :not_found
            end
        else
            render json: { error: 'Name parameter cannot be empty' }, status: :bad_request
        end
    end

private

    def merchant_params
        params.require(:merchant).permit(:name)
    end
    def not_found_response(exception)
        render json: ErrorSerializer.serialize(exception, "400"), status: :bad_request
    end

    def not_complete_response(exception)
            render json: ErrorSerializer.serialize(exception, "400"), status: :bad_request
    end

end