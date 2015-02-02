require_relative 'test_helper'

class ClientTest < Minitest::Test
  context '#todolists' do
    context 'when the request is successful' do
      setup do
        @json = <<-JSON
        [
          {
            "id": 1,
            "name": "Launch list",
            "description": "What we need for launch",
            "updated_at": "2012-03-22T16:56:52-05:00",
            "url": "https://basecamp.com/5/api/v1/projects/5-bcx/todolists/968316918-launch-list.json",
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
              "id": 5,
              "name": "BCX",
              "type": "Project",
              "url": "https://basecamp.com/5/api/v1/projects/5-bcx.json"
            }
          }
        ]
        JSON

        stub_request(:get, 'https://basecamp.com/5/api/v1/todolists.json').to_return({ :status => 200, :body => @json, :headers => { 'Content-Type' => 'application/json' } })
        @client = Basecamp::Client.new({:token => 'foo', :account_id => 5})
        @list = Basecamp::TodoList.new(JSON.parse(@json)[0].merge(:project_id => "5", :account_id => 5 ))
      end

      should 'return an array of todolists from basecamp' do
        assert_equal @list.project_id, @client.todolists[0].project_id
        assert_equal @list.account_id, @client.todolists[0].account_id
      end
    end

    context 'when the request fails' do
      setup do
        @client = Basecamp::Client.new({:token => 'foo', :account_id => 5})
        stub_request(:get, 'https://basecamp.com/5/api/v1/todolists.json').to_return({ :status => 401, :body => 'authorization_expired' })
      end

      should 'return false' do
        assert_raises Basecamp::TokenExpiredError do
          @client.todolists
        end
      end
    end
  end

  context '#projects' do
    setup do
      @json = <<-JSON
        [
          {
            "id": 605816632,
            "name": "BCX",
            "description": "The Next Generation",
            "updated_at": "2012-03-23T13:55:43-05:00",
            "url": "https://basecamp.com/999999999/api/v1/projects/605816632-bcx.json",
            "archived": false,
            "starred": true,
            "trashed": false,
            "is_client_project": false,
            "color": "3185c5"
          },
          {
            "id": 684146117,
            "name": "Nothing here!",
            "description": null,
            "updated_at": "2012-03-22T16:56:51-05:00",
            "url": "https://basecamp.com/999999999/api/v1/projects/684146117-nothing-here.json",
            "archived": false,
            "starred": false,
            "trashed": false,
            "is_client_project": true,
            "color": "3185c5"
          }
        ]
      JSON
    end

    context 'when the request fails' do
      setup do
        @client = Basecamp::Client.new({:token => 'foo', :account_id => 5})
        stub_request(:get, 'https://basecamp.com/5/api/v1/projects.json').to_return({ :status => 401, :body => 'authorization_expired' })
      end

      should 'raise a basecamp exception' do
        assert_raises(Basecamp::TokenExpiredError) do
          @client.projects
        end
      end
    end

    context 'when the request is successful' do
      setup do
        @client = Basecamp::Client.new({:token => 'foo', :account_id => 5})
        @response = [
            Basecamp::Project.new(JSON.parse(@json)[0].merge(:account_id => 5, :token => "foo")),
            Basecamp::Project.new(JSON.parse(@json)[1].merge(:account_id => 5, :token => "foo"))
        ]
        stub_request(:get, 'https://basecamp.com/5/api/v1/projects.json').to_return({ :status => 200, :body => @json, :headers => { 'Content-Type' => 'application/json' } })
      end

      should 'return an array of basecamp project objects' do
        assert_equal @response[0].attributes, @client.projects[0].attributes
        assert_equal @response[1].attributes, @client.projects[1].attributes
      end
    end
  end

  context '#people' do
    setup do
      @json = <<-JSON
        [
          {
            "id": 149087659,
            "identity_id": 982871737,
            "name": "Jason Fried",
            "email_address": "jason@basecamp.com",
            "admin": true,
            "avatar_url": "https://asset0.37img.com/global/4113d0a133a32931be8934e70b2ea21efeff72c1/avatar.96.gif",
            "fullsize_avatar_url": "https://asset0.37img.com/global/4113d0a133a32931be8934e70b2ea21efeff72c1/original.gif?r=3",
            "created_at": "2012-03-22T16:56:48-05:00",
            "updated_at": "2012-03-22T16:56:48-05:00",
            "url": "https://basecamp.com/999999999/api/v1/people/149087659-jason-fried.json"
          },
          {
            "id": 1071630348,
            "identity_id": 827377171,
            "name": "Jeremy Kemper",
            "email_address": "jeremy@basecamp.com",
            "admin": true,
            "avatar_url": "https://asset0.37img.com/global/e68cafa694e8f22203eb36f13dccfefa9ac0acb2/avatar.96.gif",
            "fullsize_avatar_url": "https://asset0.37img.com/global/4113d0a133a32931be8934e70b2ea21efeff72c1/original.gif?r=3",
            "created_at": "2012-03-22T16:56:48-05:00",
            "updated_at": "2012-03-22T16:56:48-05:00",
            "url": "https://basecamp.com/999999999/api/v1/people/1071630348-jeremy-kemper.json"
          }
        ]
      JSON
    end

    context 'when the request fails' do
      setup do
        @client = Basecamp::Client.new({:token => 'foo', :account_id => 5})
        stub_request(:get, 'https://basecamp.com/5/api/v1/people.json').to_return({ :status => 401, :body => 'authorization_expired' })
      end

      should 'raise a basecamp exception' do
        assert_raises(Basecamp::TokenExpiredError) do
          @client.people
        end
      end
    end

    context 'when the request is successful' do
      setup do
        @client = Basecamp::Client.new({:token => 'foo', :account_id => 5})
        @response = [
            Basecamp::Person.new(JSON.parse(@json)[0].merge(:account_id => 5, :token => "foo")),
            Basecamp::Person.new(JSON.parse(@json)[1].merge(:account_id => 5, :token => "foo"))
        ]
        stub_request(:get, 'https://basecamp.com/5/api/v1/people.json').to_return({ :status => 200, :body => @json, :headers => { 'Content-Type' => 'application/json' } })
      end

      should 'return an array of basecamp person objects' do
        assert_equal @response[0].attributes, @client.people[0].attributes
        assert_equal @response[1].attributes, @client.people[1].attributes
      end
    end
  end

  context '#me' do
    setup do
      @json = <<-JSON
        {
          "id": 149087659,
          "identity_id": 982871737,
          "name": "Jason Fried",
          "email_address": "jason@basecamp.com",
          "admin": true,
          "avatar_url": "https://asset0.37img.com/global/4113d0a133a32931be8934e70b2ea21efeff72c1/avatar.96.gif?r=3",
          "fullsize_avatar_url": "https://asset0.37img.com/global/4113d0a133a32931be8934e70b2ea21efeff72c1/original.gif?r=3",
          "created_at": "2012-03-22T16:56:51-05:00",
          "updated_at": "2012-03-23T13:55:43-05:00",
          "events": {
            "count": 19,
            "updated_at": "2012-03-23T13:55:43-05:00",
            "url": "https://basecamp.com/999999999/api/v1/people/149087659-jason-fried/events.json"
          },
          "assigned_todos": {
            "count": 80,
            "updated_at": "2013-06-26T16:22:05.000-04:00",
            "url": "https://basecamp.com/999999999/api/v1/people/149087659-jason-fried/assigned_todos.json"
          }
        }
      JSON
    end

    context 'when the request fails' do
      setup do
        @client = Basecamp::Client.new({:token => 'foo', :account_id => 5})
        stub_request(:get, 'https://basecamp.com/5/api/v1/people/me.json').to_return({ :status => 401, :body => 'authorization_expired' })
      end

      should 'raise a basecamp exception' do
        assert_raises(Basecamp::TokenExpiredError) do
          @client.me
        end
      end
    end

    context 'when the request is successful' do
      setup do
        @client = Basecamp::Client.new({:token => 'foo', :account_id => 5})
        @response = Basecamp::Person.new(JSON.parse(@json).merge(:account_id => 5, :token => "foo"))
        stub_request(:get, 'https://basecamp.com/5/api/v1/people/me.json').to_return({ :status => 200, :body => @json, :headers => { 'Content-Type' => 'application/json' } })
      end

      should 'return a person object' do
        assert_equal @response.attributes, @client.me.attributes
      end
    end
  end

  context '#person' do
    setup do
      @json = <<-JSON
        {
          "id": 149087659,
          "identity_id": 982871737,
          "name": "Jason Fried",
          "email_address": "jason@basecamp.com",
          "admin": true,
          "avatar_url": "https://asset0.37img.com/global/4113d0a133a32931be8934e70b2ea21efeff72c1/avatar.96.gif?r=3",
          "fullsize_avatar_url": "https://asset0.37img.com/global/4113d0a133a32931be8934e70b2ea21efeff72c1/original.gif?r=3",
          "created_at": "2012-03-22T16:56:51-05:00",
          "updated_at": "2012-03-23T13:55:43-05:00",
          "events": {
            "count": 19,
            "updated_at": "2012-03-23T13:55:43-05:00",
            "url": "https://basecamp.com/999999999/api/v1/people/149087659-jason-fried/events.json"
          },
          "assigned_todos": {
            "count": 80,
            "updated_at": "2013-06-26T16:22:05.000-04:00",
            "url": "https://basecamp.com/999999999/api/v1/people/149087659-jason-fried/assigned_todos.json"
          }
        }
      JSON
    end

    context 'when the request fails' do
      setup do
        @client = Basecamp::Client.new({:token => 'foo', :account_id => 5})
        stub_request(:get, 'https://basecamp.com/5/api/v1/people/149087659.json').to_return({ :status => 401, :body => 'authorization_expired' })
      end

      should 'raise a basecamp exception' do
        assert_raises(Basecamp::TokenExpiredError) do
          @client.person(149087659)
        end
      end
    end

    context 'when the request is successful' do
      setup do
        @client = Basecamp::Client.new({:token => 'foo', :account_id => 5})
        @response = Basecamp::Person.new(JSON.parse(@json).merge(:account_id => 5, :token => "foo"))
        stub_request(:get, 'https://basecamp.com/5/api/v1/people/149087659.json').to_return({ :status => 200, :body => @json, :headers => { 'Content-Type' => 'application/json' } })
      end

      should 'return a person object' do
        assert_equal @response.attributes, @client.person(149087659).attributes
      end
    end
  end
end