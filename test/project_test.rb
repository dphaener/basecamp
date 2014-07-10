require_relative 'test_helper'

class ProjectTest < MiniTest::Test

  context '#todolists' do
    setup do
      @json = <<-JSON
          [
            {
              "id": 968316918,
              "name": "Launch list",
              "description": "What we need for launch",
              "created_at": "2012-03-22T16:46:52-05:00",
              "updated_at": "2012-03-22T16:56:52-05:00",
              "url": "https://basecamp.com/999999999/api/v1/projects/605816632-bcx/todolists/968316918-launch-list.json",
              "completed": false,
              "position": 1,
              "private": false,
              "trashed": false,
              "completed_count": 3,
              "remaining_count": 5,
              "creator": {
                "id": 127326141,
                "name": "David Heinemeier Hansson",
                "avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/avatar.96.gif?r=3",
                "fullsize_avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/original.gif?r=3"
              },
              "bucket": {
                "id": 605816632,
                "name": "BCX",
                "type": "Project",
                "url": "https://basecamp.com/999999999/api/v1/projects/605816632-bcx.json"
              }
            }
          ]
      JSON
    end

    context 'when the request fails' do
      setup do
        @project = Basecamp::Project.new(:id => 605816632, :account_id => 1)
        stub_request(:get, "https://basecamp.com/1/api/v1/projects/605816632/todolists.json").to_return({ :status => 401, :body => 'authorization_expired', :headers => { 'Content-Type' => 'application/json' } })
      end

      should 'raise an exception' do
        assert_raises(Basecamp::TokenExpiredError) do
          @project.todolists
        end
      end
    end

    context 'when the request is successful' do
      setup do
        @project = Basecamp::Project.new(:id => 605816632, :account_id => 1)
        stub_request(:get, "https://basecamp.com/1/api/v1/projects/605816632/todolists.json").to_return({ :status => 200, :body => @json, :headers => { 'Content-Type' => 'application/json' } })
        @todolist = Basecamp::TodoList.new(JSON.parse(@json).first.merge(:account_id => 1))
      end

      should 'return an array of todo lists' do
        assert_equal @todolist.attributes, @project.todolists.first.attributes
      end
    end
  end

  context '#completed_todolists' do
    setup do
      @json = <<-JSON
          [
            {
              "id": 968316918,
              "name": "Launch list",
              "description": "What we need for launch",
              "created_at": "2012-03-22T16:46:52-05:00",
              "updated_at": "2012-03-22T16:56:52-05:00",
              "url": "https://basecamp.com/999999999/api/v1/projects/605816632-bcx/todolists/968316918-launch-list.json",
              "completed": true,
              "position": 1,
              "private": false,
              "trashed": false,
              "completed_count": 3,
              "remaining_count": 5,
              "creator": {
                "id": 127326141,
                "name": "David Heinemeier Hansson",
                "avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/avatar.96.gif?r=3",
                "fullsize_avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/original.gif?r=3"
              },
              "bucket": {
                "id": 605816632,
                "name": "BCX",
                "type": "Project",
                "url": "https://basecamp.com/999999999/api/v1/projects/605816632-bcx.json"
              }
            }
          ]
      JSON
    end

    context 'when the request fails' do
      setup do
        @project = Basecamp::Project.new(:id => 605816632, :account_id => 1)
        stub_request(:get, "https://basecamp.com/1/api/v1/projects/605816632/todolists/completed.json").to_return({ :status => 401, :body => 'authorization_expired', :headers => { 'Content-Type' => 'application/json' } })
      end

      should 'raise an exception' do
        assert_raises(Basecamp::TokenExpiredError) do
          @project.completed_todolists
        end
      end
    end

    context 'when the request is successful' do
      setup do
        @project = Basecamp::Project.new(:id => 605816632, :account_id => 1)
        stub_request(:get, "https://basecamp.com/1/api/v1/projects/605816632/todolists/completed.json").to_return({ :status => 200, :body => @json, :headers => { 'Content-Type' => 'application/json' } })
        @todolist = Basecamp::TodoList.new(JSON.parse(@json).first.merge(:account_id => 1))
      end

      should 'return an array of todo lists' do
        assert_equal @todolist.attributes, @project.completed_todolists.first.attributes
      end
    end
  end

  context '#todolist' do
    setup do
      @json = <<-JSON
        {
          "id": 1,
          "name": "Launch list",
          "description": "What we need for launch",
          "created_at": "2012-03-22T16:46:52-05:00",
          "updated_at": "2012-03-22T16:56:52-05:00",
          "url": "https://basecamp.com/999999999/api/v1/projects/605816632-bcx/todolists/968316918-launch-list.json",
          "completed": true,
          "position": 1,
          "private": false,
          "trashed": false,
          "completed_count": 3,
          "remaining_count": 5,
          "creator": {
            "id": 127326141,
            "name": "David Heinemeier Hansson",
            "avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/avatar.96.gif?r=3",
            "fullsize_avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/original.gif?r=3"
          },
          "bucket": {
            "id": 605816632,
            "name": "BCX",
            "type": "Project",
            "url": "https://basecamp.com/999999999/api/v1/projects/605816632-bcx.json"
          }
        }
      JSON
    end

    context 'when the request fails' do
      setup do
        @project = Basecamp::Project.new(:id => 605816632, :account_id => 1)
        stub_request(:get, "https://basecamp.com/1/api/v1/projects/605816632/todolists/1.json").to_return({ :status => 401, :body => 'authorization_expired', :headers => { 'Content-Type' => 'application/json' } })
      end

      should 'raise an exception' do
        assert_raises(Basecamp::TokenExpiredError) do
          @project.todolist(1)
        end
      end
    end

    context 'when the request is successful' do
      setup do
        @project = Basecamp::Project.new(:id => 605816632, :account_id => 1)
        stub_request(:get, "https://basecamp.com/1/api/v1/projects/605816632/todolists/1.json").to_return({ :status => 200, :body => @json, :headers => { 'Content-Type' => 'application/json' } })
        @todolist = Basecamp::TodoList.new(JSON.parse(@json).merge(:account_id => 1))
      end

      should 'return an array of todo lists' do
        assert_equal @todolist.attributes, @project.todolist(1).attributes
      end
    end
  end

  context '#create_todolist' do
    setup do
      @json = <<-JSON
        {
          "id": 1,
          "name": "Launch list",
          "description": "What we need for launch",
          "created_at": "2012-03-22T16:46:52-05:00",
          "updated_at": "2012-03-22T16:56:52-05:00",
          "url": "https://basecamp.com/999999999/api/v1/projects/605816632-bcx/todolists/968316918-launch-list.json",
          "completed": true,
          "position": 1,
          "private": false,
          "trashed": false,
          "completed_count": 3,
          "remaining_count": 5,
          "creator": {
            "id": 127326141,
            "name": "David Heinemeier Hansson",
            "avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/avatar.96.gif?r=3",
            "fullsize_avatar_url": "https://asset0.37img.com/global/9d2148cb8ed8e2e8ecbc625dd1cbe7691896c7d9/original.gif?r=3"
          },
          "bucket": {
            "id": 605816632,
            "name": "BCX",
            "type": "Project",
            "url": "https://basecamp.com/999999999/api/v1/projects/605816632-bcx.json"
          }
        }
      JSON
    end

    context 'when the request fails' do
      setup do
        @project = Basecamp::Project.new(:id => 605816632, :account_id => 1)
        stub_request(:post, "https://basecamp.com/1/api/v1/projects/605816632/todolists.json").to_return({ :status => 401, :body => 'authorization_expired', :headers => { 'Content-Type' => 'application/json' } })
        @list = Basecamp::TodoList.new(JSON.parse(@json).merge(:account_id => 1))
      end

      should 'raise an exception' do
        assert_raises(Basecamp::TokenExpiredError) do
          @project.create_todolist(@list)
        end
      end
    end

    context 'when the request is successful' do
      setup do
        @project = Basecamp::Project.new(:id => 605816632, :account_id => 1)
        stub_request(:post, "https://basecamp.com/1/api/v1/projects/605816632/todolists.json").to_return({ :status => 200, :body => @json, :headers => { 'Content-Type' => 'application/json' } })
        @todolist = Basecamp::TodoList.new(JSON.parse(@json).merge(:account_id => 1))
      end

      should 'return an array of todo lists' do
        assert_equal @todolist.attributes, @project.create_todolist(@todolist).attributes
      end
    end
  end
end