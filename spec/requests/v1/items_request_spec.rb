require "rails_helper"

describe "Items API" do
    before(:each) do
        @merchant = Merchant.create!(name: 'Test Merchant')
        @item1 = @merchant.items.create(
            name: 'Cheese',
            description: 'Smells Bad',
            unit_price: 100.00,
            merchant: @merchant
        )
        @item2 = @merchant.items.create(
            name: 'Bread',
            description: 'Freshly Baked',
            unit_price: 50.00,
            merchant: @merchant
        )
        @item3 = @merchant.items.create(
            name: 'Milk',
            description: 'Dairy Product',
            unit_price: 75.00,
            merchant: @merchant
        )
        @item4 = @merchant.items.create(
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
            expect(item[:id]).to be_an(String)
            # check for type

            expect(item[:attributes][:name]).to be_a(String)

            expect(item[:attributes][:description]).to be_a(String)

            expect(item[:attributes][:unit_price]).to be_a(Float)
        end
    end

    it 'displays all items sorted by price' do
        get '/api/v1/items?sort=unit_price'

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)

        prices = items[:data].map { |item| item[:attributes][:unit_price] }
        expect(prices).to eq(prices.sort)

        items[:data].each do |item|
            expect(item[:id]).to be_an(String)
            expect(item[:attributes][:description]).to be_a(String)
        end
    end

    it "displays one item" do
        get "/api/v1/items/#{@item1.id}"

        expect(response).to be_successful

        items= JSON.parse(response.body, symbolize_names: true)

        
            expect(@item1.name).to be_a(String)
            expect(@item1.name).to eq('Cheese')

            expect(@item1.description).to be_a(String)
            expect(@item1.description).to eq('Smells Bad')

            expect(@item1.unit_price).to be_a(Float)
            expect(@item1.unit_price).to eq(100.00)

        get "/api/v1/items/#{@item2.id}"

        expect(response).to be_successful

        items= JSON.parse(response.body, symbolize_names: true)

        
            expect(@item2.name).to be_a(String)
            expect(@item2.name).to eq('Bread')

            expect(@item2.description).to be_a(String)
            expect(@item2.description).to eq('Freshly Baked')

            expect(@item2.unit_price).to be_a(Float)
            expect(@item2.unit_price).to eq(50.00)
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

