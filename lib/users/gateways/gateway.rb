require 'persistence'
require 'json'

module Users
  module Gateways
    class Gateway
      include Support::ValidationHelpers

      def backend_for_users
        @users_gateway_backend ||= new_backend
      end

      private

      def new_backend
        Persistence::Gateways::UsersGatewayBackend.new
      end

    end
  end
end
