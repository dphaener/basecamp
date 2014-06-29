require 'basecamp/version'
require 'basecamp/oauth'
require 'basecamp/error'
require 'basecamp/client'
require 'basecamp/todo'
require 'basecamp/todo_list'
require 'virtus'

module Basecamp
  class << self
    attr_accessor :client_id, :client_secret

    def configure
      yield self
    end
  end
end