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
end