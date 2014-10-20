require 'json'

module Users
  module Gateways
    class Gateway
      include Support::ValidationHelpers

      def backend_for_users
        Gateways::UsersGatewayBackend.new
      end

    end
  end
end