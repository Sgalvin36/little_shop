require "rails_helper"

RSpec.describe Merchant, type: :model do
    describe "instance methods" do
        describe "#item_count" do
            it "gets a count of a merchants items" do
                
                merchant1 = Merchant.create(name: "Skippy")
                
                item1 = Item.create(
                    name: 'Cheese',
                    description: 'Smells Bad',
                    unit_price: 100.00,
                    merchant: merchant1
                )
                item2 = Item.create(
                    name: 'Bread',
                    description: 'Freshly Baked',
                    unit_price: 50.00,
                    merchant: merchant1
                )
                item3 = Item.create(
                    name: 'Milk',
                    description: 'Dairy Product',
                    unit_price: 75.00,
                    merchant: merchant1
                )

                expect(merchant1.item_count).to eq(3)

            end
        end
    end

    describe "class methods" do
        it "sorts merchants by created_at attribute" do
            Merchant.destroy_all
            merchants = create_list(:merchant, 3)

            expect(Merchant.sorted_by_created_at).to eq([merchants[2], merchants[1], merchants[0]])
        end

        # it "filters by status" do

        # end
    end
end