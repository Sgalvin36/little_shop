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