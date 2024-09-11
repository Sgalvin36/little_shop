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
    end
end