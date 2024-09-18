require "rails_helper"

RSpec.describe Item, type: :model do
    describe "instance methods" do
    end

    describe "validation" do
        it {should validate_presence_of(:unit_price)}
        it {should validate_numericality_of(:unit_price)}
    end

    describe "#param_check" do
        it "returns the unique response if one of the errors is found" do
            error_1 = {name: "Steve", min_price: 32.00}
            save = Item.param_check(error_1)
            expect(save).to eq("Cannot send name and price together")

            error_2 = {min_price: -32.00}
            save = Item.param_check(error_2)
            expect(save).to eq("Minimum price needs to be greater than 0")

            error_3 = {max_price: -32.00}
            save = Item.param_check(error_3)
            expect(save).to eq("Maximum price needs to be greater than 0")
        
            error_4 = {name: ""}
            save = Item.param_check(error_4)
            expect(save).to eq("Name query cannot be blank")

            error_5 = {}
            save = Item.param_check(error_5)
            expect(save).to eq("No queries provided")
        end
    end
end