module Basecamp
  class OAuth

    # The token to use for requests
    attr_reader :token

    # The refresh token provided by basecamp during initial authorization. Needed to
    # get a new token when the token expires
    attr_reader :refresh_token

    # The client_secret that is defined in the initializer file
    attr_reader :client_secret

    # The client_id that is defined in the initializer file
    attr_reader :client_id

    def initialize(params = {})
      @token = params[:token]
      @refresh_token = params[:refresh_token]
      @client_id = Basecamp.client_id
      @client_secret = Basecamp.client_secret
    end

    # The parameters hash to pass into the OAuth2 client
    def client_params
      {
          :site => "https://launchpad.37signals.com",
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

    # Requests a new token from the Basecamp servers
    def get_new_token
      response = client.auth_code.get_token(nil)
      {
          :token => response.token,
          :expires_at => Time.at(response.expires_at)
      }

    rescue OAuth2::Error => ex
      Basecamp::Error.new(ex.message).raise_exception
    end

    # Returns an array of all basecamp accounts associated with this token
    def get_accounts
      response = access_token.get("https://launchpad.37signals.com/authorization.json")
      JSON.parse(response.body)["accounts"]
    rescue => ex
      Basecamp::Error.new(ex.message).raise_exception
    end
  end
end