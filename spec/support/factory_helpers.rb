module Support
  module FactoryHelpers

    def create_user(options = {})
      user    = build_user(options)
      gateway = Users::Gateways::UserGateway.new

      uid = gateway.add user
      gateway.get uid
    end

    def build_user(opts = {})
      Users::Entities::User.new(
        'nickname', 'email', 'auth_key', opts
      )
    end

  end
end