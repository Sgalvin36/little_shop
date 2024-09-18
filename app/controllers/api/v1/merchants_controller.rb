class Api::V1::MerchantsController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :not_found_response
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
    end

    def destroy
        merchant = Merchant.find(params[:id])
        render json: merchant.destroy, status:204
    end

    def find
        if params[:name].present?
            merchants = Merchant.where("name ILIKE ?", "%#{params[:name]}%").order(:name)
            if merchants.any?
                render json: MerchantSerializer.new(merchants.first)
            else
                render json: ErrorSerializer.custom_error("Merchant not found", "200"), status: :ok
            end
        else
            render json: ErrorSerializer.custom_error("Name parameter cannot be empty", "400"), status: :bad_request
        end
    end

private

    def merchant_params
        params.require(:merchant).permit(:name)
    end

    def not_found_response(exception)
        render json: ErrorSerializer.serialize(exception, "400"), status: :bad_request
    end
end