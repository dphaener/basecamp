require_relative 'test_helper'

class PersonTest < MiniTest::Test
  context '#delete' do
    context 'when the user is not authorized to delete this person' do
      setup do

      end

      should 'raise an unauthorized basecamp error' do

      end
    end

    context 'when the request fails for another reason' do

    end

    context 'when the request is successful' do

    end
  end
end