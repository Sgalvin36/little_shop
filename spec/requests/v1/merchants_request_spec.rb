require "rails_helper"

RSpec.describe Merchant do
    before(:each) do
        Merchant.destroy_all

        @merchants = create_list(:merchant, 3)
    end

    describe "#index" do
        it "returns all merchant objects" do
            merchant_names = [@merchants[0][:name], @merchants[1][:name], @merchants[2][:name]]

            get "/api/v1/merchants"

            expect(response).to be_successful
            
            allMerchants = JSON.parse(response.body, symbolize_names: true)

            expect(allMerchants[:data].length).to eq(3)
            allMerchants[:data].each do |merchant|
                expect(merchant).to have_key(:id)
                expect(merchant_names).to include(merchant[:attributes][:name])
            end
        end

        it "returns a sorted list of all merchants newest to oldest" do

            get "/api/v1/merchants?sort=desc"

            expect(response).to be_successful
            sortedMerchants = JSON.parse(response.body, symbolize_names: true)
            expect((sortedMerchants[:data][0][:id]).to_s).to eq(@merchants[2][:id].to_s)
            expect((sortedMerchants[:data][2][:id]).to_s).to eq(@merchants[0][:id].to_s)
        end

        it "returns a list of all merchants with returned items" do
            customer = create(:customer)
            create(:invoice, merchant_id: @merchants[0].id, status: "returned", customer_id: customer.id)

            get "/api/v1/merchants?status=returned"

            expect(response).to be_successful
            merchants_with_invoice = JSON.parse(response.body, symbolize_names: true)
            
            expect(merchants_with_invoice[:data].count).to eq(1)
            expect(merchants_with_invoice[:data][0][:attributes][:name]).to eq(@merchants[0].name)

            create(:invoice, merchant_id: @merchants[2].id, status: "returned", customer_id: customer.id)

            get "/api/v1/merchants?status=returned"

            expect(response).to be_successful
            merchants_with_invoice = JSON.parse(response.body, symbolize_names: true)
            
            expect(merchants_with_invoice[:data].count).to eq(2)
           
            expect(merchants_with_invoice[:data][1][:attributes][:name]).to eq(@merchants[2].name)

            create(:invoice, merchant_id: @merchants[1].id, status: "shipped", customer_id: customer.id)

            get "/api/v1/merchants?status=returned"

            expect(response).to be_successful
            merchants_with_invoice = JSON.parse(response.body, symbolize_names: true)

            expect(merchants_with_invoice[:data].count).to eq(2)
        end

        it "returns a list of all merchants with item counts" do
            item1 = Item.create(
                name: 'Cheese',
                description: 'Smells Bad',
                unit_price: 100.00,
                merchant: @merchant1
            )
            item2 = Item.create(
                name: 'Bread',
                description: 'Freshly Baked',
                unit_price: 50.00,
                merchant: @merchant1
            )
            item3 = Item.create(
                name: 'Milk',
                description: 'Dairy Product',
                unit_price: 75.00,
                merchant: @merchant1
            )

            get "/api/v1/merchants?count=true"

            expect(response).to be_successful
            
            allMerchants = JSON.parse(response.body, symbolize_names: true)
            expect(allMerchants[:data][0][:attributes][:item_count]).to eq(3)
        end
    end

    describe "show" do
        it "returns a single merchant" do
            get "/api/v1/merchants/#{@merchant1[:id]}"

            singleMerchant = JSON.parse(response.body, symbolize_names: true)

            expect(response).to be_successful
            expect(singleMerchant[:data][:attributes][:name]).to eq ("Skippy")
        end
    end

    describe "#create" do
        it "creates a new merchant" do 
            merchant_params = {
                name: "Joe"
            }
            headers = { "CONTENT_TYPE" => "application/json" }

            post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant: merchant_params)

            created_merchant = Merchant.last
            
            expect(response).to be_successful
            expect(created_merchant.name).to eq("Joe")
        end

        describe "#patch" do
            it "can edit a resource" do
              merchant1 = Merchant.create(name: "Sammy")
              merchant2 = Merchant.create(name: "James")
               
                updated_merchant_params = {name: "Saul" }
                headers = { "CONTENT_TYPE" => "application/json"}

              patch "/api/v1/merchants/#{merchant1.id}", headers: headers, params: JSON.generate(merchant: updated_merchant_params)
              
              expect(response).to be_successful

              new_merchant = JSON.parse(response.body, symbolize_names: true)

              expect(new_merchant[:data][:type]).to eq ("merchant")
              expect(new_merchant[:data][:attributes][:name]). to eq("Saul")

              updated_merchant = Merchant.find(merchant1.id)
              expect(updated_merchant.name).to eq("Saul")
              expect(merchant2.name).to eq("James")
            end
        end
    end
    
    describe "#delete" do
        it 'can delete a merchant' do
            expect(Merchant.count).to eq(3)

            delete "/api/v1/merchants/#{@merchant1.id}"

            expect(response).to be_successful
            expect(Merchant.count).to eq(2)

            removed_merchant = Merchant.find_by(id: @merchant1.id)
            expect(removed_merchant).to be_nil

            expect(Merchant.find(@merchant2.id)).to eq(@merchant2)
        end
    end
end