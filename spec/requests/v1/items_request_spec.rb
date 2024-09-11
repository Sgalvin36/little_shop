require 'rails_helper'

describe "Items API" do
    before(:all) do

    end

    it "creates a new item" do
        new_id = Merchant.create(name: "Joe").id
        
        item_params = {name: "JOY",
        description: "To the World, my program works!",
        unit_price: 42.00,
        merchant_id: new_id
        }

        headers = { "CONTENT_TYPE" => "application/json" }

        post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
        create_item = Item.last

        expect(response).to be_successful

        item = Item.last
        expect(item.name).to eq("JOY")
        expect(item.description).to eq("To the World, my program works!")
        expect(item.unit_price).to eq(42.00)
        expect(item.merchant_id).to eq(new_id)
    end
end