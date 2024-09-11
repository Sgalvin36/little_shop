require "rails_helper"

describe "Items API" do
    before(:all) do
        Item.destroy_all
        @merchant = Merchant.create!(name: 'Test Merchant')
        @item1 = Item.create(
            name: 'Cheese',
            description: 'Smells Bad',
            unit_price: 100.00,
            merchant: @merchant
        )
        @item2 = Item.create(
            name: 'Bread',
            description: 'Freshly Baked',
            unit_price: 50.00,
            merchant: @merchant
        )
        @item3 = Item.create(
            name: 'Milk',
            description: 'Dairy Product',
            unit_price: 75.00,
            merchant: @merchant
        )
        @item4 = Item.create(
            name: 'Butter',
            description: 'Creamy and Rich',
            unit_price: 120.00,
            merchant: @merchant
        )
    end

    it 'displays a list of all items' do
        get '/api/v1/items'

        expect(response).to be_successful


        items = JSON.parse(response.body, symbolize_names: true)

        items[:data].each do |item|
            expect(item[:id].to_i).to be_an(Integer)

            expect(item[:attributes]).to have_key(:name)
            expect(item[:attributes][:name]).to be_a(String)

            expect(item[:attributes]).to have_key(:description)
            expect(item[:attributes][:description]).to be_a(String)

            expect(item[:attributes]).to have_key(:unit_price)
            expect(item[:attributes][:unit_price]).to be_a(Float)
        end
    end

    it "creates a new item" do
        item_params = {name: "pizza",
        description: "The best handheld food around!",
        unit_price: 42.00,
        merchant_id: @merchant.id
        }

        headers = { "CONTENT_TYPE" => "application/json" }

        post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
        create_item = Item.last

        expect(response).to be_successful

        item = Item.last
        expect(item.name).to eq("pizza")
        expect(item.description).to eq("The best handheld food around!")
        expect(item.unit_price).to eq(42.00)
        expect(item.merchant_id).to eq(new_id)
    end

    it "can update an existing Item" do 
        item_id = Item.create({name: "Pizza",
        description: "Topped with pineapple!",
        unit_price: 42.00,
        merchant_id: @merchant.id}).id

        previous_price = Item.last.unit_price
        item_params = { unit_price: 80.25 }
        headers = {"CONTENT_TYPE" => "application/json"}
        
        patch "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate({item: item_params})
        item = Item.find_by(id: item_id)
        expect(response).to be_successful
        expect(item.unit_price).to_not eq(previous_price)
        expect(item.unit_price).to eq(80.25)
    end

    it "can destroy an item" do
        item = Item.create(name: "REGRET",
            description: "Hard work rarely pays off.",
            price: 69.00,
            merchant_id: @merchant.id)
        
        expect(Item.count).to eq(5)
    
        delete "/api/v1/items/#{item.id}"
    
        expect(response).to be_successful
        expect(Item.count).to eq(10)
        expect{Item.find(poster.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
end
