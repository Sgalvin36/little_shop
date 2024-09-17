class ErrorSerializer
    def self.serialize(error, status)
      {
        "message": "Your status code is #{status}",
        "errors": error.message.split(", ")
      }
    end

    def self.no_record_for_id
      {
        "message": "Your status code is 404",
        "errors": "No records found for id"
      }
    end
end
