class ErrorSerializer
    def self.errorserialize(error, status)
        {
          "message": "Your status code is #{status}",
          "errors": error.message
        }
    end
end