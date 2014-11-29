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
        :nickname => options[:nickname] || 'nickname',
        :email => options[:email] || 'email',
        :auth_key => options[:auth_key] || 'auth_key',
        :favorites => options[:favorities] || [],
        :added => options[:added] || [],
        :terms => true,
        :last_login_time => options[:last_login_time] || 1234,
        :last_login_address => options[:last_login_address] || '23.0.2.5',
        :login_count => options[:login_count] || 23
      }
    end

  end
end
