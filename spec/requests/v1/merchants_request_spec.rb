require "rails_helper"

RSpec.describe Merchant do
    before(:all) do
        Merchant.destroy_all
        @merchant1 = Merchant.create(name: "Skippy")
        @merchant2 = Merchant.create(name: "Pippy")
        @merchant3 = Merchant.create(name: "Flippy")
    end
    
    describe "#index" do
        it "returns all merchant objects" do

            nameArray = ["Skippy", "Pippy", "Flippy"]

            get "/api/v1/merchants"

            expect(response).to be_successful
            
            allMerchants = JSON.parse(response.body, symbolize_names: true)
            expect(allMerchants[:data].count).to eq(3)
            allMerchants[:data].each do |merchant|
                expect(merchant).to have_key(:id)
                expect(nameArray).to include(merchant[:attributes][:name])
            end
        end

        it "returns a sorted list of all merchants newest to oldest" do

            get "/api/v1/merchants?sort=desc"

            expect(response).to be_successful
            sortedMerchants = JSON.parse(response.body, symbolize_names: true)
            expect((sortedMerchants[:data][0][:id]).to_s).to eq(@merchant3[:id].to_s)
            expect((sortedMerchants[:data][2][:id]).to_s).to eq(@merchant1[:id].to_s)
        end

        it "returns a list of all merchants with returned items" do

            #simulate return a merchant1 item

            Invoice.create!(
                merchant_id: @merchant1[:id],
                status: "returned"
            )
            get "/api/v1/merchants?status=returned"

            expect(response).to be_successful
            merchantsWithInvoice = JSON.parse(response.body, symbolize_names: true)
            
            expect(merchantsWithInvoice[:data].count).to eq(1)
            
            #simulate return a merchant2 item

            Invoice.create(
                merchant_id: @merchant2[:id],
                status: "returned",
            )

            get "/api/v1/merchants?status=returned"

            expect(response).to be_successful
            merchantsWithInvoice = JSON.parse(response.body, symbolize_names: true)
            
            expect(merchantsWithInvoice[:data].count).to eq(2)
        end

        xit "returns a list of all merchants with item counts" do
            item1 = Item.create(
                name: 'Cheese',
                description: 'Smells Bad',
                unit_price: 100.00,
                merchant: @merchant1
            )
            item2 = Item.create(
                name: 'Bread',
                description: 'Freshly Baked',
                unit_price: 50.00,
                merchant: @merchant1
            )
            item3 = Item.create(
                name: 'Milk',
                description: 'Dairy Product',
                unit_price: 75.00,
                merchant: @merchant1
            )

            get "/api/v1/merchants?count=true"

            expect(response).to be_successful
            
            allMerchants = JSON.parse(response.body, symbolize_names: true)
            expect(allMerchants[:data][0][:attributes][:item_count]).to eq(3)
        end
    end

    describe "show" do
        it "returns a single merchant" do
            get "/api/v1/merchants/#{@merchant1[:id]}"

            singleMerchant = JSON.parse(response.body, symbolize_names: true)

            expect(response).to be_successful
            expect(singleMerchant[:data][:attributes][:name]).to eq ("Skippy")
        end
    end

    describe "#create" do
        it "creates a new merchant" do 
            merchant_params = {
                name: "Joe"
            }
            headers = { "CONTENT_TYPE" => "application/json" }

            post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant: merchant_params)

            created_merchant = Merchant.last
            
            expect(response).to be_successful
            expect(created_merchant.name).to eq("Joe")
        end
    end
end