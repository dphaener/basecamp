require_relative 'test_helper'

class TodoListTest < Minitest::Test
  context '#create_todo' do
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
        @todo_list = Basecamp::TodoList.new(:id => 1000, :project_id => 5, :account_id => 1)
        stub_request(:post, "https://basecamp.com/1/api/v1/projects/5/todolists/1000/todos.json").to_return({ :status => 200, :body => @json, :headers => { 'Content-Type' => 'application/json' } })
        @todo = Basecamp::Todo.new(JSON.parse(@json))
      end

      should 'return a new basecamp todo object' do
        assert_equal @todo.attributes, @todo_list.create_todo(@todo).attributes
      end
    end

    context 'when the request fails' do
      setup do
        @todo_list = Basecamp::TodoList.new(:id => 1000, :project_id => 5, :account_id => 1)
        stub_request(:post, "https://basecamp.com/1/api/v1/projects/5/todolists/1000/todos.json").to_return({ :status => 401, :body => 'authorization_expired' })
        @todo = Basecamp::Todo.new(JSON.parse(@json))
      end

      should 'raise an exception' do
        assert_raises(Basecamp::TokenExpiredError) do
          @todo_list.create_todo(@todo)
        end
      end
    end
  end
end