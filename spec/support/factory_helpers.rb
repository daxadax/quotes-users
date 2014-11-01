module Support
  module FactoryHelpers

    def create_user(options = {})
      user = build_user(options)
      gateway = Users::Gateways::UserGateway.new

      uid = gateway.add user
      gateway.get uid
    end

    def build_user(options = {})
      nickname = options[:nickname] || 'nickname'
      email = options[:email] || 'email'
      auth_key = options[:auth_key] || 'auth_key'

      Users::Entities::User.new(
        nickname, email, auth_key, options
      )
    end

    def build_serialized_user(options = {})
      {
        :nickname   => options[:nickname]   || 'nickname',
        :email         => options[:email]      || 'email',
        :auth_key => options[:auth_key]   || 'auth_key',
        :favorites  => options[:favorities] || [],
        :added      => options[:added]      || [],
        :terms       => true
      }
    end

  end
end
