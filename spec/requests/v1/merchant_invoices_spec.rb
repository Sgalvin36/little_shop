require "rails_helper"

describe "Merchant Invoices API" do
    before(:all) do
        Invoice.destroy_all
        @merchant = Merchant.create!(name: 'Test Merchant')
        @customer1 = create(:customer)
        @customer2 = create(:customer)
        create_list(:invoice, 4, merchant_id: @merchant.id, status:"shipped", customer_id:@customer1.id)
        create_list(:invoice, 4, merchant_id: @merchant.id, status:"returned", customer_id:@customer2.id)
        create_list(:invoice, 4, merchant_id: @merchant.id, status:"packaged", customer_id:@customer1.id)
    end

    it 'displays a list of all items' do
        get "/api/v1/merchants/#{@merchant.id}/invoices"
        
        expect(response).to be_successful

        invoices = JSON.parse(response.body, symbolize_names: true)

        invoices[:data].each do |invoice|
            expect(invoice[:id]).to be_a(String)

            expect(invoice[:attributes][:status]).to be_a(String)

            expect(invoice[:attributes][:customer_id]).to be_a(String)

            expect(item[:attributes][:merchant_id]).to be_a(@merchant.id)
        end
    end
end
