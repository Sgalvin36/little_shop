require "rails_helper"

describe "Items API" do
    before(:all) do
        Item.destroy_all
        @merchant = Merchant.create!(name: 'Test Merchant')
        create_list(:item, 4, merchant_id: @merchant.id)  
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


    describe "#POST" do
        it "creates a new item" do
            item_params = {name: "pizza",
            description: "The best handheld food around!",
            unit_price: 42.00,
            merchant_id: @merchant.id
            }

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
            expect(item.merchant_id).to eq(@merchant.id)
        end
    end

    describe "#PATCH" do
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
    end

    describe "#DELETE" do
        it "can destroy an item" do
            item = Item.create(name: "REGRET",
                description: "Hard work rarely pays off.",
                unit_price: 69.00,
                merchant_id: @merchant.id)
            
            expect(Item.count).to eq(5)
        
            delete "/api/v1/items/#{item.id}"
        
            expect(response).to be_successful
            expect(Item.count).to eq(4)
            expect{Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
    end

    
    
end

