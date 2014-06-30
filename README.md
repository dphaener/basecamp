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

## Contributing

1. Fork it ( http://github.com/<my-github-username>/basecamp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
