require "rails_helper"

describe "Items API" do
    before(:all) do
        Item.destroy_all
        @merchant = Merchant.create!(name: 'Test Merchant')
        @items = create_list(:item, 4, merchant_id: @merchant.id)  
    end

    describe "#GET" do
        it 'displays a list of all items' do
            get '/api/v1/items'

            expect(response).to be_successful


            items = JSON.parse(response.body, symbolize_names: true)

            

            items[:data].each do |item|
                expect(item[:id]).to be_an(String)
                expect(item[:type]).to eq("item")

                expect(item[:attributes][:name]).to be_a(String)
                expect(item[:attributes][:description]).to be_a(String)
                expect(item[:attributes][:unit_price]).to be_a(Float)
            end
        end   

        it 'displays all items sorted by price' do
            get '/api/v1/items?sorted=unit_price'

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
            items = create_list(:item, 2, merchant_id: @merchant.id)
            get "/api/v1/items/#{items[0].id}"

            expect(response).to be_successful

            item1 = JSON.parse(response.body, symbolize_names: true)
            item1 = item1[:data]

            expect(item1[:id].to_i).to eq(items[0].id)
            expect(item1[:type]).to eq("item")
            expect(item1[:attributes][:name]).to eq(items[0].name)
            expect(item1[:attributes][:description]).to eq(items[0].description)
            expect(item1[:attributes][:unit_price]).to eq(items[0].unit_price)

            get "/api/v1/items/#{items[1].id}"

            expect(response).to be_successful

            item2 = JSON.parse(response.body, symbolize_names: true)
            item2 = item2[:data]

            expect(item2[:id].to_i).to eq(items[1].id)
            expect(item2[:type]).to eq("item")
            expect(item2[:attributes][:name]).to eq(items[1].name)
            expect(item2[:attributes][:description]).to eq(items[1].description)
            expect(item2[:attributes][:unit_price]).to eq(items[1].unit_price)
        end
    end

    describe "#POST" do
        it "creates a new item" do
            item_params = {name: "pizza",
                description: "The best handheld food around!",
                unit_price: 42.00,
                merchant_id: @merchant.id
                }

            headers = { "CONTENT_TYPE" => "application/json" }

            post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

            expect(response).to be_successful

            item = Item.last
            expect(item.name).to eq(item_params[:name])
            expect(item.description).to eq(item_params[:description])
            expect(item.unit_price).to eq(item_params[:unit_price])
            expect(item.merchant_id).to eq(item_params[:merchant_id])
        end
        
        describe "SAD path" do
            it "responds with an error if parameters are left empty" do
                item_params = {name: "pizza",
                description: "The best handheld food around!",
                unit_price:'',
                merchant_id: @merchant.id
                }

                headers = { "CONTENT_TYPE" => "application/json" }

                post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

                expected = {
                    errors: ["Validation failed: Unit price can't be blank", "Unit price is not a number"],
                    message: "Your status code is 422"
                } 

                response_body = JSON.parse(response.body, symbolize_names: true)
    
                expect(response_body).to eq(expected)
            end

            it "responds with an error if parameters are left empty" do
                item_params = {name: "pizza",
                description: "The best handheld food around!",
                unit_price:'seven',
                merchant_id: @merchant.id
                }

                headers = { "CONTENT_TYPE" => "application/json" }

                post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

                expected = {
                    errors: ["Validation failed: Unit price is not a number"],
                    message: "Your status code is 422"
                } 

                response_body = JSON.parse(response.body, symbolize_names: true)
    
                expect(response_body).to eq(expected)
            end
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
            
            put "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate({item: item_params})
            item = Item.find_by(id: item_id)

            expect(response).to be_successful
            expect(item.unit_price).to_not eq(previous_price)
            expect(item.unit_price).to eq(80.25)
        end

        describe "SAD path" do
            it "returns expected error message when no id is given" do
                item_id = Item.create({name: "Pizza",
                description: "Topped with pineapple!",
                unit_price: 42.00,
                merchant_id: @merchant.id}).id
    
                previous_price = Item.last.unit_price
                item_params = { unit_price: 80.25 }
                headers = {"CONTENT_TYPE" => "application/json"}
                
                put "/api/v1/items/''", headers: headers, params: JSON.generate({item: item_params})
                
                expected = {
                    errors: ["Couldn't find Item with 'id'=''"],
                    message: "Your status code is 404"
                } 

                response_body = JSON.parse(response.body, symbolize_names: true)
    
                expect(response_body).to eq(expected)
            end

            it "returns expected error message when id is not found" do
                item_id = Item.create({name: "Pizza",
                description: "Topped with pineapple!",
                unit_price: 42.00,
                merchant_id: @merchant.id}).id
    
                previous_price = Item.last.unit_price
                item_params = { unit_price: 80.25 }
                headers = {"CONTENT_TYPE" => "application/json"}
                
                put "/api/v1/items/1098145987671", headers: headers, params: JSON.generate({item: item_params})

                expected = {
                    errors: ["Couldn't find Item with 'id'=1098145987671"],
                    message: "Your status code is 404"
                } 
    
                response_body = JSON.parse(response.body, symbolize_names: true)
    
                expect(response_body).to eq(expected)
            end

            it "returns expected error message when no id is given" do
                item_id = Item.create({name: "Pizza",
                description: "Topped with pineapple!",
                unit_price: 42.00,
                merchant_id: @merchant.id}).id
    
                previous_price = Item.last.unit_price
                item_params = { merchant_id: nil }
                headers = {"CONTENT_TYPE" => "application/json"}
                
                put "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate({item: item_params})
                
                expected = {
                    errors: ["Validation failed: Merchant must exist"],
                    message: "Your status code is 400"
                } 

                response_body = JSON.parse(response.body, symbolize_names: true)
    
                expect(response_body).to eq(expected)
            end
            
            it "returns expected error message when changed parameter is blank" do
                item_id = Item.create({name: "Pizza",
                description: "Topped with pineapple!",
                unit_price: 42.00,
                merchant_id: @merchant.id}).id
    
                previous_price = Item.last.unit_price
                item_params = { unit_price: '' }
                headers = {"CONTENT_TYPE" => "application/json"}
                
                put "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate({item: item_params})

                expected = {
                    errors: ["Validation failed: Unit price can't be blank", "Unit price is not a number"],
                    message: "Your status code is 422"
                } 
    
                response_body = JSON.parse(response.body, symbolize_names: true)
    
                expect(response_body).to eq(expected)
            end

            it "returns expected error message when changed parameter is wrong type" do
                item_id = Item.create({name: "Pizza",
                description: "Topped with pineapple!",
                unit_price: 42.00,
                merchant_id: @merchant.id}).id
    
                previous_price = Item.last.unit_price
                item_params = { unit_price: 'seven'}
                headers = {"CONTENT_TYPE" => "application/json"}
                
                put "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate({item: item_params})

                expected = {
                    errors: ["Validation failed: Unit price is not a number"],
                    message: "Your status code is 422"
                } 
    
                response_body = JSON.parse(response.body, symbolize_names: true)
    
                expect(response_body).to eq(expected)
            end
        end
    end

    describe "#DELETE" do
        it "can destroy an item" do
            item = create(:item, merchant_id: @merchant.id)

            expect(Item.count).to eq(5)
        
            delete "/api/v1/items/#{item.id}"
        
            expect(response).to be_successful
            expect(Item.count).to eq(4)
            expect{Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "can destroy item invoices associated with the item" do
            item = create(:item, merchant_id: @merchant.id)
            customer1 = create(:customer)
            customer2 = create(:customer)
            
            invoice1 = create(:invoice, merchant_id: @merchant.id, status:"shipped", customer_id:customer1.id)
            invoice2 = create(:invoice, merchant_id: @merchant.id, status:"shipped", customer_id:customer2.id)
            
            create(:invoice_item, item_id: item.id, invoice_id: invoice1)
            create(:invoice_item, item_id: item.id, invoice_id: invoice1)
            
            
            expect(Item.count).to eq(5)
            expect(InvoiceItem.count).to eq(2)
        
            delete "/api/v1/items/#{item.id}"
        
            expect(response).to be_successful
            expect(Item.count).to eq(4)
            expect(InvoiceItem.count).to eq(0)
            expect{Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end

        describe "SAD path" do
            it "returns expected error message when no id is given" do
                expected = {
                    errors: ["Couldn't find Item with 'id'=''"],
                    message: "Your status code is 404"
                } 
    
                delete "/api/v1/items/''"
                response_body = JSON.parse(response.body, symbolize_names: true)
    
                expect(response_body).to eq(expected)
            end

            it "returns expected error message when id is not found" do
                expected = {
                    errors: ["Couldn't find Item with 'id'=71"],
                    message: "Your status code is 404"
                } 
    
                delete "/api/v1/items/71"
                response_body = JSON.parse(response.body, symbolize_names: true)
    
                expect(response_body).to eq(expected)
            end
        end
    end

    describe "find by search" do

        it "returns merchant data for a given item ID" do
            
            get "/api/v1/items/#{@items[1].id}/merchant"
        
            expect(response).to be_successful 

            merchant_items = JSON.parse(response.body, symbolize_names: true)
        
            expect(merchant_items[:data][:id]).to eq(@merchant.id.to_s)  
        end 
        
        it "finds all items based on search criteria" do
            get "/api/v1/items/find_all?name=#{@items[0].name}"

            expect(response).to be_successful

            found_items= JSON.parse(response.body, symbolize_names: true)

            expect(found_items[:data][0][:id].to_i).to eq(@items[0].id)
            expect(found_items[:data][0][:attributes][:name]).to eq(@items[0].name)
        end

        it "finds all items based on partial search" do
            item1 = create(:item, merchant_id: @merchant.id, name: "Funko-Pops")
            item2 = create(:item, merchant_id: @merchant.id, name: "Pop-Pops")
            item3 = create(:item, merchant_id: @merchant.id, name: "Opposites")
            
            search = "op"
            get "/api/v1/items/find_all?name=#{search}"

            expect(response).to be_successful

            found_items= JSON.parse(response.body, symbolize_names: true)
            expect(found_items[:data].count).to be >= 3
        end

        it "responds gracefully to empty search parameters" do
            item1 = create(:item, merchant_id: @merchant.id, name: "Funko-Pops")
            item2 = create(:item, merchant_id: @merchant.id, name: "Pop-Pops")
            item3 = create(:item, merchant_id: @merchant.id, name: "Opposites")
            
            search = ""
            get "/api/v1/items/find_all?name=#{search}"

            expected_error = { "data": {
                "message": "Your status code is 400",
                "errors": ["Name query cannot be blank"]
                }
            }

            expect(response).to_not be_successful
            expect(response.status).to eq(400)
            error = JSON.parse(response.body, symbolize_names: true)

            expect(error).to eq(expected_error)
        end

        it "responds gracefully to no search parameters" do
            item1 = create(:item, merchant_id: @merchant.id, name: "Funko-Pops")
            item2 = create(:item, merchant_id: @merchant.id, name: "Pop-Pops")
            item3 = create(:item, merchant_id: @merchant.id, name: "Opposites")
            
            search = ""
            get "/api/v1/items/find_all?"

            expected_error = { "data": {
                "message": "Your status code is 400",
                "errors": ["No queries provided"]
                }
            }

            expect(response).to_not be_successful
            expect(response.status).to eq(400)
            error = JSON.parse(response.body, symbolize_names: true)

            expect(error).to eq(expected_error)
        end

        it 'filter items by min_price' do
            get '/api/v1/items/find_all?min_price=10.00'

            expect(response).to be_successful

            filter_items = JSON.parse(response.body, symbolize_names: true)

            filter_items[:data].each do |item|
                expect(item[:attributes][:unit_price]).to be >= 10.00
            end
        end

        it 'filter items by max_price' do
            get '/api/v1/items/find_all?max_price=20.00'

            expect(response).to be_successful

            filter_items = JSON.parse(response.body, symbolize_names: true)

            filter_items[:data].each do |item|
                expect(item[:attributes][:unit_price]).to be <= 20.00
            end
        end

        it 'filter items by min_price and max_price' do
            get '/api/v1/items/find_all?min_price=10.00&max_price=20.00'

            expect(response).to be_successful

            filter_items = JSON.parse(response.body, symbolize_names: true)

            filter_items[:data].each do |item|
                expect(item[:attributes][:unit_price]).to be_between(10.00, 20.00)
            end
        end
    end
end

