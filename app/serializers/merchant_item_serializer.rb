class MerchantItemSerializer
    def self.serialize(merchants)
        {
            "data": merchants.map do |merchant|
                {
                    "id": merchant.id.to_s,
                        "type": merchant.name.to_s,
                        "attributes": {
                            "name": merchant.name.to_s,
                            "item_count": merchant.item_count
                        }
                }
            end
        }
    end
end
