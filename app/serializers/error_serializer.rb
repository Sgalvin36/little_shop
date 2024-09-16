class ErrorSerializer
    def self.serialize(error, status)
        {
          "message": "Your status code is #{status}",
          "errors": error.message
        }
    end
end
