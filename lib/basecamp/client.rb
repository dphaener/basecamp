require 'virtus'
require 'oauth2'

# Adapted from https://github.com/birarda/logan/blob/master/lib/logan/client.rb

module Basecamp
  class Client
    include Virtus.model

    attribute :account_id, Integer
    attribute :token, String
    attribute :refresh_token, String

    # The client_secret that is defined in the initializer file
    attr_reader :client_secret

    # The client_id that is defined in the initializer file
    attr_reader :client_id

    def initialize(params = {})
      @client_id = Basecamp.client_id
      @client_secret = Basecamp.client_secret
      super(params)
    end

    # The parameters hash to pass into the OAuth2 client
    def client_params
      {
          :site => "https://basecamp.com/#{account_id}/api/v1",
          :token_url => "/authorization/token?type=refresh&refresh_token=#{refresh_token}",
          :authorize_url => "/authorization/new"
      }
    end

    # Initialize the OAuth2 client
    def client
      @client ||= OAuth2::Client.new(client_id, client_secret, client_params)
    end

    # We have to create an access token object using the current valid token in order to
    # be able to send requests to the api
    def access_token
      @access_token ||= OAuth2::AccessToken.new(client, token)
    end

    def base_uri
      "https://basecamp.com/#{account_id}/api/v1"
    end

    # get active Todo lists for all projects from Basecamp API
    #
    # @return [Array<Basecamp::TodoList>] array of {Basecamp::TodoList} instances
    def todolists
      response = access_token.get("#{base_uri}/todolists.json")
      [].tap do |ary|
        response.parsed.each do |list|
          ary << Basecamp::TodoList.new(list.merge(:account_id => account_id, :token => token))
        end
      end
    rescue => ex
      Basecamp::Error.new(ex.message).raise_exception
    end

    def projects
      response = access_token.get("#{base_uri}/projects.json")
      [].tap do |ary|
        response.parsed.each do |project|
          ary << Basecamp::Project.new(project.merge(:account_id => account_id, :token => token))
        end
      end
    rescue => ex
      Basecamp::Error.new(ex.message).raise_exception
    end
    
    def me 
      response = access_token.get("#{base_uri}/people/me.json").parsed
      Basecamp::Person.new(:account_id => account_id, :token => token, :name => response["name"], :email_address => response["email_address"])
    rescue => ex
      Basecamp::Error.new(ex.message).raise_exception
    end
    
  end
end