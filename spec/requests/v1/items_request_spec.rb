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

    it "can update an existing Item" do
        new_id = Merchant.create(name: "Joe").id
        
        item_id = Item.create({name: "JOY",
        description: "To the World, my program works!",
        unit_price: 42.00,
        merchant_id: new_id}).id

        previous_price = Item.last.unit_price
        item_params = { unit_price: 80.25 }
        headers = {"CONTENT_TYPE" => "application/json"}
        
        patch "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate({item: item_params})
        item = Item.find_by(id: item_id)
        expect(response).to be_successful
        expect(item.unit_price).to_not eq(previous_price)
        expect(item.unit_price).to eq(80.25)
    end
end