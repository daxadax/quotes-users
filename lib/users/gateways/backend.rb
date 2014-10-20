require 'sqlite3'
require 'sequel'

module Users
  module Gateways
    class Backend
      include Support::ValidationHelpers

      def initialize
        @database = retrieve_database
      end

      private

      def retrieve_database
        if ENV['test']
          Sequel.connect('sqlite://users-test.db')
        else
          Sequel.sqlite('/home/dd/programming/quotes/users/users-development.db')
        end
      end
    end
  end
end