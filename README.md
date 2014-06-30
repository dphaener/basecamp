[![Code Climate](https://codeclimate.com/github/dphaener/basecamp.png)](https://codeclimate.com/github/dphaener/basecamp)

# Basecamp

This gem provides a simple wrapper for the Basecamp API (New, version 1) using OAuth authentication only.
Currently it only supports functionality for Todos, TodoLists and Projects

## Installation

Add this line to your application's Gemfile:

    gem 'basecamp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install basecamp

## Usage

### Rails

Add the following to a file in your config directory

    Basecamp.configure do |c|
      c.client_id = <your basecamp client_id>
      c.client_secret = <your basecamp secret>
    end

#### OAuth2

This gem uses OAuth2 exclusively for authentication. Basecamp periodically expires their tokens, and they must be 
refreshed to continue to gain access to the API. There are methods included to facilitate this.

##### Initialize a new OAuth2 instance

    oauth = Basecamp::OAuth.new(:token => <the users token>, :refresh_token => <the users refresh token>)
    
##### Get an array of all accounts associated with this token

    oauth.get_accounts
    
##### Request a new token from Basecamp

    oauth.get_new_token
    
#### Client

The client object creates an instance of a Basecamp OAuth client and provides methods to get an array of todo lists
and an array of projects associated with the users token

##### Initialize a new instance of the client

    client = Basecamp::Client.new(:token => <the users token>, :account_id => <the basecamp account to access>)
    
##### Get an array of todo lists. Returns an array of Basecamp::Todolist objects

    client.todolists
    
##### Get an array of projects. Returns an array of Basecamp::Project objects

    client.projects
    
## Contributing

1. Fork it ( http://github.com/dphaener/basecamp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
