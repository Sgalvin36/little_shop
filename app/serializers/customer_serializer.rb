class CustomerSerializer
    include JSONAPI::Serializer

    attriburtes :first_name, :last_name
end