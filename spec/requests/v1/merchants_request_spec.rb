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
            items = create_list(:item, 3, merchant_id: @merchants[0].id)
            items2 = create_list(:item, 4, merchant_id: @merchants[1].id)
            items3 = create_list(:item, 6, merchant_id: @merchants[2].id)

            get "/api/v1/merchants?count=true"

            expect(response).to be_successful
            
            allMerchants = JSON.parse(response.body, symbolize_names: true)

            expect(allMerchants[:data][0][:attributes][:item_count]).to eq(3)
            expect(allMerchants[:data][1][:attributes][:item_count]).to eq(4)
            expect(allMerchants[:data][2][:attributes][:item_count]).to eq(6)
        end
    end

    describe "#show" do
        it "returns a single merchant" do
            get "/api/v1/merchants/#{@merchants[0].id}"

            singleMerchant = JSON.parse(response.body, symbolize_names: true)

            expect(response).to be_successful
            expect(singleMerchant[:data][:attributes][:name]).to eq (@merchants[0].name)
        end
    end

    describe "#create" do
        it "creates a new merchant" do 
            merchant_params = {
                name: "Joe"
            }
            headers = { "CONTENT_TYPE" => "application/json" }

            expect(Merchant.all.count).to eq(3)

            post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant: merchant_params)

            created_merchant = Merchant.last
            
            expect(response).to be_successful
            expect(created_merchant.name).to eq("Joe")
            expect(Merchant.all.count).to eq(4)
        end
    end

    describe "#patch" do
        it "can edit a resource" do
            old_merchant = @merchants[1]
            updated_merchant_params = {name: "Saul" }
            headers = { "CONTENT_TYPE" => "application/json"}

            patch "/api/v1/merchants/#{@merchants[1].id}", headers: headers, params: JSON.generate(merchant: updated_merchant_params)
            
            expect(response).to be_successful

            new_merchant = JSON.parse(response.body, symbolize_names: true)

            expect(new_merchant[:data][:type]).to eq ("merchant")
            expect(new_merchant[:data][:attributes][:name]). to eq("Saul")

            updated_merchant = Merchant.find(@merchants[1].id)
            expect(updated_merchant.name).to_not eq(old_merchant.name)
            expect(updated_merchant.name).to eq("Saul")
        end
        it "returns merchant data for a given item ID" do
        
            get "/api/v1/merchants/#{@merchant.id}/items"
        
            expect(response).to be_successful 
    
            merchant_items = JSON.parse(response.body, symbolize_names: true)
        
            expect(merchant_items[:data][:id]).to eq(@merchant.id.to_s)  
        end
    end
    
    describe "#delete" do
        it 'can delete a merchant' do
            expect(Merchant.count).to eq(3)
            old_id = @merchants[1].id
            delete "/api/v1/merchants/#{old_id}"

            expect(response).to be_successful
            expect(Merchant.count).to eq(2)

            removed_merchant = Merchant.find_by(id: old_id)
            expect(removed_merchant).to be_nil
            expect{Merchant.find(old_id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
    end
end