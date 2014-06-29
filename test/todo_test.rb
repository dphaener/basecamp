require_relative 'test_helper'

class TodoTest < Minitest::Test
  context '#update' do
    setup do
      @json = <<-JSON
          {
            "id": 1,
            "todolist_id": 1000,
            "position": 1,
            "content": "Design it",
            "completed": true,
            "due_at": "2012-03-27",
            "created_at": "2012-03-24T09:53:35-05:00",
            "updated_at": "2012-03-24T10:56:33-05:00",
            "comments_count": 1,
            "private": false,
            "trashed": false,
            "creator": {
              "id": 127326141,
              "name": "David Heinemeier Hansson",
              "avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/avatar.96.gif?r=3",
              "fullsize_avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/original.gif?r=3"
            },
            "assignee": {
              "id": 149087659,
              "type": "Person",
              "name": "Jason Fried"
            },
            "comments": [
              {
                "id": 1028592764,
                "content": "+1",
                "created_at": "2012-03-24T09:53:34-05:00",
                "updated_at": "2012-03-24T09:53:34-05:00",
                "creator": {
                  "id": 127326141,
                  "name": "David Heinemeier Hansson",
                  "avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/avatar.96.gif?r=3",
                  "fullsize_avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/original.gif?r=3"
                }
              }
            ],
            "subscribers": [
              {
                "id": 149087659,
                "name": "Jason Fried"
              },
              {
                "id": 1071630348,
                "name": "Jeremy Kemper"
              }
            ]
          }
      JSON
    end

    context 'when the request is successful' do
      setup do
        stub_request(:put, 'https://basecamp.com/4/api/v1/projects/5/todos/1.json').to_return({ :status => 200, :body => @json, :headers => { 'Content-Type' => 'application/json' } })
        @todo = Basecamp::Todo.new(JSON.parse(@json).merge(:account_id => 4, :token => 'foo', :project_id => 5))
      end

      should 'return true' do
        assert @todo.update
      end
    end

    context 'when the request is not successful' do
      setup do
        @todo = Basecamp::Todo.new(JSON.parse(@json).merge(:account_id => 4, :token => 'foo', :project_id => 5))
        stub_request(:put, 'https://basecamp.com/4/api/v1/projects/5/todos/1.json').to_return({ :status => 401, :body => 'authorization_expired' })
      end

      should 'raise an exception' do
        assert_raises Basecamp::TokenExpiredError do
          @todo.update
        end
      end
    end
  end

  context '#refresh' do
    setup do
      @json = <<-JSON
          {
            "id": 1,
            "todolist_id": 1000,
            "position": 1,
            "content": "Design it",
            "completed": true,
            "due_at": "2012-03-27",
            "created_at": "2012-03-24T09:53:35-05:00",
            "updated_at": "2012-03-24T10:56:33-05:00",
            "comments_count": 1,
            "private": false,
            "trashed": false,
            "creator": {
              "id": 127326141,
              "name": "David Heinemeier Hansson",
              "avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/avatar.96.gif?r=3",
              "fullsize_avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/original.gif?r=3"
            },
            "assignee": {
              "id": 149087659,
              "type": "Person",
              "name": "Jason Fried"
            },
            "comments": [
              {
                "id": 1028592764,
                "content": "+1",
                "created_at": "2012-03-24T09:53:34-05:00",
                "updated_at": "2012-03-24T09:53:34-05:00",
                "creator": {
                  "id": 127326141,
                  "name": "David Heinemeier Hansson",
                  "avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/avatar.96.gif?r=3",
                  "fullsize_avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/original.gif?r=3"
                }
              }
            ],
            "subscribers": [
              {
                "id": 149087659,
                "name": "Jason Fried"
              },
              {
                "id": 1071630348,
                "name": "Jeremy Kemper"
              }
            ]
          }
      JSON
    end

    context 'when the request is successful' do
      setup do
        @todo = Basecamp::Todo.new(:account_id => 4, :token => 'foo', :project_id => 5, :id => 1)
        @new_todo = Basecamp::Todo.new(JSON.parse(@json).merge(:account_id => 4, :token => 'foo', :project_id => 5))
        stub_request(:get, 'https://basecamp.com/4/api/v1/projects/5/todos/1.json').to_return({ :status => 200, :body => @json, :headers => { 'Content-Type' => 'application/json' } })
        @todo.refresh
      end

      should 'get the updated information and re-initialize the object with the new data' do
        assert_equal @new_todo.attributes, @todo.attributes
      end
    end

    context 'when the request fails' do
      setup do
        @todo = Basecamp::Todo.new(:account_id => 4, :token => 'foo', :project_id => 5, :id => 1)
        stub_request(:get, 'https://basecamp.com/4/api/v1/projects/5/todos/1.json').to_return({ :status => 401, :body => 'authorization_expired' })
      end

      should 'raise an exception' do
        assert_raises(Basecamp::TokenExpiredError) do
          @todo.refresh
        end
      end
    end
  end

  context '#delete' do
    setup do
      @json = <<-JSON
          {
            "id": 1,
            "todolist_id": 1000,
            "position": 1,
            "content": "Design it",
            "completed": true,
            "due_at": "2012-03-27",
            "created_at": "2012-03-24T09:53:35-05:00",
            "updated_at": "2012-03-24T10:56:33-05:00",
            "comments_count": 1,
            "private": false,
            "trashed": false,
            "creator": {
              "id": 127326141,
              "name": "David Heinemeier Hansson",
              "avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/avatar.96.gif?r=3",
              "fullsize_avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/original.gif?r=3"
            },
            "assignee": {
              "id": 149087659,
              "type": "Person",
              "name": "Jason Fried"
            },
            "comments": [
              {
                "id": 1028592764,
                "content": "+1",
                "created_at": "2012-03-24T09:53:34-05:00",
                "updated_at": "2012-03-24T09:53:34-05:00",
                "creator": {
                  "id": 127326141,
                  "name": "David Heinemeier Hansson",
                  "avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/avatar.96.gif?r=3",
                  "fullsize_avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/original.gif?r=3"
                }
              }
            ],
            "subscribers": [
              {
                "id": 149087659,
                "name": "Jason Fried"
              },
              {
                "id": 1071630348,
                "name": "Jeremy Kemper"
              }
            ]
          }
      JSON
    end

    context 'when the request is successful' do
      setup do
        @todo = Basecamp::Todo.new(:account_id => 4, :token => 'foo', :project_id => 5, :id => 1)
        stub_request(:delete, 'https://basecamp.com/4/api/v1/projects/5/todos/1.json').to_return({ :status => 204 })
      end

      should 'return true' do
        assert @todo.delete
      end
    end

    context 'when the request fails' do
      setup do
        @todo = Basecamp::Todo.new(:account_id => 4, :token => 'foo', :project_id => 5, :id => 1)
        stub_request(:delete, 'https://basecamp.com/4/api/v1/projects/5/todos/1.json').to_return({ :status => 403, :body => 'Forbidden' })
      end

      should 'raise an exception' do
        assert_raises(Basecamp::GeneralException) do
          @todo.delete
        end
      end
    end
  end
end