require 'virtus'

module Basecamp
  class Person
    include Virtus.model

    attribute :id, Integer
    attribute :identity_id, Integer
    attribute :name, String
    attribute :email_address, String
    attribute :admin, Boolean
    attribute :avatar_url, String
    attribute :fullsize_avatar_url, String
    attribute :created_at, DateTime
    attribute :updated_at, DateTime
    attribute :events, Hash
    attribute :assigned_todos, Hash
    attribute :url, String
    attribute :account_id, Integer
    attribute :token, String

    def initialize(params = {})
      super(params)
    end


  end
end