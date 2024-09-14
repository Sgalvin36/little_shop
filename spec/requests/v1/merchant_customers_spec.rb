require "rails_helper"

describe "Merchant customer API" do
  before(:all) do
    Invoice.destroy_all
    Customer.destroy_all
    Merchant.destroy_all

    @merchant = create(:merchant)
    @customer1 = create(:customer)
    @customer2 = create(:customer)

    create_list(:invoice, 2, merchant_id: @merchant.id, status: "shipped", customer_id: @customer1.id)
    create_list(:invoice, 3, merchant_id: @merchant.id, status: "returned", customer_id: @customer2.id)
    
  end

  it 'returns a list of all customers for a merchant' do
    get "/api/v1/merchants/#{@merchant.id}/customers"

    puts "Response Status: #{response.status}"

    expect(response).to be_successful

    customers = JSON.parse(response.body, symbolize_names: true)

    expect(customers[:data].length).to eq(2) # Adjust based on your test data

    customers[:data].each do |customer|
      expect(customer[:id]).to be_a(String)
      expect(customer[:attributes][:first_name]).to be_a(String)
      expect(customer[:attributes][:last_name]).to be_a(String)
    end
  end
end