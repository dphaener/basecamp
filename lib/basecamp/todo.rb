require 'virtus'

module Basecamp
  class Todo
    include Virtus.model

    attribute :id, Integer
    attribute :project_id, Integer
    attribute :account_id, Integer
    attribute :todolist_id, Integer
    attribute :token, String
    attribute :content, String
    attribute :completed, Boolean
    attribute :trashed, Boolean
    attribute :comments_count, Integer
    attribute :assignee, Hash
    attribute :due_at, Time
    attribute :position, Integer

    def initialize(params = {})
      super(params)
    end

    def post_json
      {
          :content => @content
      }.to_json
    end

    def put_json
      {
          :content => @content,
          :due_at => @due_at,
          :assignee => @assignee.empty? ? nil : @assignee.to_hash,
          :position => @position ? 99  : @position,
          :completed => @completed
      }.to_json
    end

    def client
      @client ||= Basecamp::Client.new(:account_id => account_id, :token => token)
    end

    # refreshes the data for this todo from the API
    def refresh
      response = client.access_token.get("#{client.base_uri}/projects/#{project_id}/todos/#{id}.json")
      initialize(response.parsed)
      true
    rescue OAuth2::Error => ex
      Basecamp::Error.new(ex.message).raise_exception
    end

    # updates the todo on Basecamp
    def update
      response = client.access_token.put("#{client.base_uri}/projects/#{project_id}/todos/#{id}.json") do |request|
        request.headers['Content-Type'] = 'application/json'
        request.body = put_json
      end
      true
    rescue OAuth2::Error => ex
      Basecamp::Error.new(ex.message).raise_exception
    end

    # delete the todo on Basecamp
    def delete
      response = client.access_token.delete("#{client.base_uri}/projects/#{@project_id}/todos/#{id}.json")
      true
    rescue OAuth2::Error => ex
      Basecamp::Error.new(ex.message).raise_exception
    end
  end
end