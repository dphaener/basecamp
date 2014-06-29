module Basecamp
  class GeneralException < StandardError
    def initialize(message)
      super(message)
    end
  end

  class ClientNotFoundError < StandardError
    def initialize(message)
      super(message)
    end
  end

  class ClientSecretError < StandardError
    def initialize(message)
      super(message)
    end
  end

  class TokenExpiredError < StandardError
    def initialize(message)
      super(message)
    end
  end

  class TokenMissingError < StandardError
    def initialize(message)
      super(message)
    end
  end

  class AccessDeniedError < StandardError
    def initialize(message)
      super(message)
    end
  end

  class Error
    attr_accessor :message

    MESSAGE_MAPPING = {
        /Client not found/i => Basecamp::ClientNotFoundError,
        /Client secret/i => Basecamp::ClientSecretError,
        /authorization_expired/i => Basecamp::TokenExpiredError,
        /token missing/i => Basecamp::TokenMissingError
    }

    def initialize(message)
      @message = message
    end

    def get_exception_class
      matches = MESSAGE_MAPPING.keys.select { |regex| message =~ regex }

      matches.any? ? MESSAGE_MAPPING[matches.first] : Basecamp::GeneralException
    end

    def raise_exception
      raise get_exception_class.new(message)
    end
  end
end