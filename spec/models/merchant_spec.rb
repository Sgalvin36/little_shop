require "rails_helper"

RSpec.describe Merchant, type: :model do
    describe "instance methods" do
        describe "#get_all_merchants" do
         it "returns all merchant objects" do
            merchant1 = Merchant.new(name: "Skippy")
            merchant2 = Merchant.new(name: "Pippy")
            merchant3 = Merchant.new(name: "Flippy")

            get "/api/v1/merchants"

            expect(response).to be_successful
            
            allMerchants = Json.parse(response.body, symbolize_names: true)

            expect(allMerchants[:data]).to eq([merchant1, merchant2, merchant3])
         end
        end
    end
end