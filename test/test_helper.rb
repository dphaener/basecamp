require 'simplecov'
SimpleCov.command_name 'Unit Tests'
SimpleCov.start

require File.expand_path('../../lib/basecamp', __FILE__)

require 'shoulda'
require 'minitest/autorun'
require 'mocha/setup'
require 'webmock/minitest'
require 'minitest/reporters'
require 'json'

Minitest::Reporters.use! Minitest::Reporters::RubyMineReporter.new

