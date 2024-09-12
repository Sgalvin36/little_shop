require "rails_helper"

RSpec.describe Merchant do
    before(:each) do
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
            expect(allMerchants[:data].length).to eq(3)
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
end