require 'bound'

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

        Result.new(:error => nil, :uid => update_user )
      end

      private

      def failure(error)
        Result.new(:error => error, :uid => nil)
      end

      def authentic?(nickname)
        auth = Services::Authenticator.new.for(nickname, auth_key)
        auth == uid ? true : false
      end

      def update_user
        user = build_user
        add_to_gateway user
      end

      def build_user
        old_user = gateway.get(uid)

        nickname  = updates.fetch(:nickname) { old_user.nickname }
        email  = updates.delete(:email) { old_user.email }
        auth_key = updates.delete(:auth_key) { old_user.auth_key }
        options = updates.merge(:uid => old_user.uid)

        Entities::User.new(nickname, email, auth_key, options)
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
