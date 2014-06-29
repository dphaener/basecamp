require 'basecamp/todo'

module Basecamp
  # Adapted from https://github.com/birarda/logan/blob/master/lib/logan/todolist.rb
  class TodoList
    include Virtus.model

    attribute :id, Integer
    attribute :project_id, Integer
    attribute :project_name, String
    attribute :account_id, Integer
    attribute :name, String
    attribute :description, String
    attribute :completed, Boolean
    attribute :remaining_count, Integer
    attribute :completed_count, Integer
    attribute :url, String
    attribute :token, String

    attr_accessor :remaining_todos, :completed_todos, :trashed_todos

    # intializes a todo list by calling the HashConstructed initialize method and
    # setting both @remaining_todos and @completed_todos to empty arrays
    def initialize(params = {})
      if params['todos']
        @remaining_todos = set_todos_array(params['todos']['remaining'])
        @completed_todos = set_todos_array(params['todos']['completed'])
        @trashed_todos = set_todos_array(params['todos']['trashed'])
      end

      @project_name = params['bucket']['name'] rescue nil
      @project_id = params['bucket']['id'] rescue nil
      super(params)
    end

    def client
      @client = Basecamp::Client.new(:account_id => account_id, :token => token)
    end

    def set_todos_array(todos)
      [].tap do |ary|
        todos.each { |todo| ary << Basecamp::Todo.new(todo.merge(:project_id => project_id, :account_id => account_id)) }
      end
    end

    # refreshes the data for this todo list from the API
    def refresh_list
      response = client.access_token.get("#{client.base_uri}/projects/#{project_id}/todolists/#{id}.json")
      initialize(response.parsed)
    end

    # create a todo in this todo list via the Basecamp API
    #
    # @param [Basecamp::Todo] todo the todo instance to create in this todo list
    # @return [Basecamp::Todo] the created todo returned from the Basecamp API
    def create_todo(todo)
      response = client.access_token.post("#{client.base_uri}/projects/#{project_id}/todolists/#{id}/todos.json") do |request|
        request.body = todo.post_json
        request.headers['Content-Type'] = 'application/json'
      end
      Basecamp::Todo.new(response.parsed)
    rescue OAuth2::Error => ex
      Basecamp::Error.new(ex.message).raise_exception
    end

    def todos
      remaining_todos + completed_todos
    end
  end
end