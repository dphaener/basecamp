require 'virtus'

module Basecamp
  class Person
    include Virtus.model

    attribute :account_id, Integer
    attribute :token, String
    attribute :name, String
    attribute :email_address, String
    
    def initialize(params = {})
      super(params)
    end

  end
end