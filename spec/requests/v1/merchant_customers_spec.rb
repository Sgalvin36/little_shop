require 'rails_helper'

RSpec.describe 'Merchant customer API' do 
    before(:each) do 
        Invoice.destroy_all
        Merchant.destroy_all
        Customer.destroy_all

        @merchant = Merchant.create!(name: 'Test Merchant')
        @customer1 = create(:customer)
        @customer2 = create(:customer)

        create_list(:invoice, 2, merchant: @merchant, status: "shipped", customer: @customer1)
        create_list(:invoice, 3, merchant: @merchant, status: "returned", customer: @customer2)
  
    end

    it 'returns list of all customers of a merchant' do
        get "/api/v1/merchants/#{@merchat.id}/customers"

        expect(respone).to be_successful

        customers = JSON.parse(response.body, symbolize_names: true)

        expect(customers[:data].length).to eq(2)

        customers[:data].each do |customer|
            expect(customer[:type]).to be_a(String)
            expect(customer[:id]).to be_a(String)
            expect(customer[:attributes][:first_name]).to be_a(String)
            expect(customer[:attributes][:last_name]).to be_a(String)

        end
    end
end