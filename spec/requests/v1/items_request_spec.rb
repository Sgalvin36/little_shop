require "rails_helper"

describe "items_request_spec" do
  before(:each) do
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
end

