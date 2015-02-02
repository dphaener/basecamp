require 'virtus'

module Basecamp
  class Project
    include Virtus.model

    attribute :id, Integer
    attribute :name, String
    attribute :description, String
    attribute :updated_at, DateTime
    attribute :url, String
    attribute :archived, Boolean
    attribute :starred, Boolean
    attribute :trashed, Boolean
    attribute :is_client_project, Boolean
    attribute :color, String
    attribute :account_id, Integer
    attribute :token, String

    def initialize(params = {})
      super(params)
    end

    # Initialize the OAuth2 client
    def client
      @client ||= Basecamp::Client.new(:account_id => account_id, :token => token)
    end

    # get active todo lists for this project from Basecamp API
    # 
    # @return [Array<Basecamp::TodoList>] array of active todo lists for this project
    def todolists
      response = client.access_token.get("#{client.base_uri}/projects/#{id}/todolists.json")
      lists = response.parsed.map do |list|
        Basecamp::TodoList.new(list.merge({
          :account_id => account_id,
          :token => token
        }))
      end

    rescue OAuth2::Error => ex
      Basecamp::Error.new(ex.message).raise_exception
    end

    # get completed todo lists for this project from Basecamp API
    # 
    # @return [Array<Basecamp::TodoList>] array of completed todo lists for this project
    def completed_todolists
      response = client.access_token.get("#{client.base_uri}/projects/#{id}/todolists/completed.json")
      lists = response.parsed.map do |list|
        Basecamp::TodoList.new(list.merge({
          :account_id => account_id,
          :token => token
        }))
      end

    rescue OAuth2::Error => ex
      Basecamp::Error.new(ex.message).raise_exception
    end

    # get both active and completed todo lists for this project from Basecamp API
    # 
    # @return [Array<Basecamp::TodoList>] array of active and completed todo lists for this project
    def all_todolists
      todolists + completed_todolists
    end

    # get an individual todo list for this project from Basecamp API
    # 
    # @param [String] list_id id for the todo list
    # @return [Basecamp::TodoList] todo list instance
    def todolist(list_id)
      response = client.access_token.get("#{client.base_uri}/projects/#{id}/todolists/#{list_id}.json")
      Basecamp::TodoList.new(response.parsed.merge({
        :account_id => account_id,
        :token => token
      }))

    rescue OAuth2::Error => ex
      Basecamp::Error.new(ex.message).raise_exception
    end

    # create a todo list in this project via Basecamp API
    # 
    # @param [Basecamp::TodoList] todo_list todo list instance to be created
    # @return [Basecamp::TodoList] todo list instance from Basecamp API response
    def create_todolist(todo_list)
      response = client.access_token.post("#{client.base_uri}/projects/#{id}/todolists.json") do |request|
        request.body = todo_list.post_json
        request.headers['Content-Type'] = 'application/json'
      end

      Basecamp::TodoList.new(response.parsed.merge({
        :account_id => account_id,
        :token => token
      }))

    rescue OAuth2::Error => ex
      Basecamp::Error.new(ex.message).raise_exception
    end

    # TODO: Add the person object so we can add these routes
    # def accesses
    #   response = Basecamp::Client.get "/projects/#{@id}/accesses.json"
    #   response.parsed_response.map { |h| p = Basecamp::Person.new(h) }
    # end
    #
    # def add_user_by_id(id)
    #   post_params = {
    #       :body => { ids: [id] }.to_json,
    #       :headers => Basecamp::Client.headers.merge({'Content-Type' => 'application/json'})
    #   }
    #
    #   response = Basecamp::Client.post "/projects/#{@id}/accesses.json", post_params
    # end
    #
    # def add_user_by_email(email)
    #   post_params = {
    #       :body => { email_addresses: [email] }.to_json,
    #       :headers => Basecamp::Client.headers.merge({'Content-Type' => 'application/json'})
    #   }
    #
    #   response = Basecamp::Client.post "/projects/#{@id}/accesses.json", post_params
    # end
  end
end