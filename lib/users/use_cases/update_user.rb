require 'bound'
require 'bcrypt'

module Users
  module UseCases
    class UpdateUser < UseCase

      Result = Bound.new(:error, :uid)

      def initialize(input)
        ensure_valid_input!(input)

        @uid = input[:uid]
        @updates = input[:updates]
        @auth_key = input[:auth_key]
        @error = nil
      end

      def call
        user = gateway.get(uid)

        return failure(:user_not_found) unless user
        return failure(:auth_failure) unless authentic?(user.nickname)

        Result.new(:error => nil, :uid => update(user) )
      end

      private

      def failure(error)
        Result.new(:error => error, :uid => nil)
      end

      def authentic?(nickname)
        auth = Services::Authenticator.new.for(nickname, auth_key)
        auth == uid ? true : false
      end

      def update(user)
        if updates.has_key?(:auth_key)
          updates[:auth_key] = BCrypt::Password.create updates[:auth_key]
        end

        user.update(updates)
        add_to_gateway user
      end

      def add_to_gateway(user)
        gateway.update user
      end

      def error
          @error
      end

      def uid
        @uid
      end

      def updates
        @updates
      end

      def auth_key
        @auth_key
      end

      def ensure_valid_input!(input)
        input.each_pair do |key, value|
          reason = "The given #{key} was blank or missing"

          if value.nil? || (value.kind_of?(String) && value.empty?)
            raise_argument_error(reason, value)
          end
        end
      end

    end
  end
end
