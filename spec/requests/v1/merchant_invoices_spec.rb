require "rails_helper"

describe "Merchant Invoices API" do
    before(:all) do
        Invoice.destroy_all
        
        @merchant = Merchant.create!(name: 'Test Merchant')
        @customer1 = create(:customer)
        @customer2 = create(:customer)
        create_list(:invoice, 2, merchant_id: @merchant.id, status:"shipped", customer_id:@customer1.id)
        create_list(:invoice, 3, merchant_id: @merchant.id, status:"returned", customer_id:@customer2.id)
        create_list(:invoice, 4, merchant_id: @merchant.id, status:"packaged", customer_id:@customer1.id)
    end

    it 'displays a list of all invoices' do
        get "/api/v1/merchants/#{@merchant.id}/invoices"

        expect(response).to be_successful

        invoices = JSON.parse(response.body, symbolize_names: true)

        expect(invoices[:data].length).to eq(9)

        invoices[:data].each do |invoice|
            expect(invoice[:id]).to be_a(String)

            expect(invoice[:attributes][:status]).to be_a(String)

            expect(invoice[:attributes][:customer_id]).to be_a(Integer)

            expect(invoice[:attributes][:merchant_id]).to eq(@merchant.id)
        end
    end

    it 'displays a list of all packaged invoices' do
        get "/api/v1/merchants/#{@merchant.id}/invoices?status=packaged"

        expect(response).to be_successful

        invoices = JSON.parse(response.body, symbolize_names: true)

        expect(invoices[:data].length).to eq(4)
        
        invoices[:data].each do |invoice|
            expect(invoice[:id]).to be_a(String)

            expect(invoice[:attributes][:status]).to eq("packaged")

            expect(invoice[:attributes][:customer_id]).to be_a(Integer)

            expect(invoice[:attributes][:merchant_id]).to eq(@merchant.id)
        end
    end

    it 'displays a list of all returned invoices' do
        get "/api/v1/merchants/#{@merchant.id}/invoices?status=returned"

        expect(response).to be_successful

        invoices = JSON.parse(response.body, symbolize_names: true)

        expect(invoices[:data].length).to eq(3)
        
        invoices[:data].each do |invoice|
            expect(invoice[:id]).to be_a(String)

            expect(invoice[:attributes][:status]).to eq("returned")

            expect(invoice[:attributes][:customer_id]).to be_a(Integer)

            expect(invoice[:attributes][:merchant_id]).to eq(@merchant.id)
        end
    end

    it 'displays a list of all shipped invoices' do
        get "/api/v1/merchants/#{@merchant.id}/invoices?status=shipped"

        expect(response).to be_successful

        invoices = JSON.parse(response.body, symbolize_names: true)

        expect(invoices[:data].length).to eq(2)
        
        invoices[:data].each do |invoice|
            expect(invoice[:id]).to be_a(String)

            expect(invoice[:attributes][:status]).to eq("shipped")

            expect(invoice[:attributes][:customer_id]).to be_a(Integer)

            expect(invoice[:attributes][:merchant_id]).to eq(@merchant.id)
        end
    end
end
