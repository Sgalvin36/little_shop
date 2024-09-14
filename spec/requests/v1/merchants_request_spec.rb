require "rails_helper"

RSpec.describe Merchant do
    describe "instance methods" do
        
        
        describe "#index" do
            it "returns all merchant objects" do
                merchant1 = Merchant.create(name: "Skippy")
                merchant2 = Merchant.create(name: "Pippy")
                merchant3 = Merchant.create(name: "Flippy")
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
                merchant1 = Merchant.create(name: "Skippy")
                merchant2 = Merchant.create(name: "Pippy")
                merchant3 = Merchant.create(name: "Flippy")
                

                get "/api/v1/merchants?sort=desc"

                expect(response).to be_successful
                sortedMerchants = JSON.parse(response.body, symbolize_names: true)
                expect((sortedMerchants[:data][0][:id]).to_s).to eq(merchant3[:id].to_s)
                expect((sortedMerchants[:data][2][:id]).to_s).to eq(merchant1[:id].to_s)
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
        it "returns merchant data for a given item ID" do
        
            get "/api/v1/merchants/#{@merchant.id}/items"
        
            expect(response).to be_successful 
    
            merchant_items = JSON.parse(response.body, symbolize_names: true)
        
            expect(merchant_items[:data][:id]).to eq(@merchant.id.to_s)  
        end
    end
end