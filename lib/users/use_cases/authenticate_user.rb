module Users
  module UseCases
    class AuthenticateUser < UseCase

      Result = Bound.required(
        :error,
        :user_uid
      )

      def initialize(input)
        ensure_valid_input!(input)

        @nickname = input[:nickname]
        @auth_key = input[:auth_key]
      end

      def call
        authenticate_user

        Result.new(:error => error, :user_uid => user_uid)
      end

      private

      def authenticate_user
        @authenticator ||= authenticator.for(nickname, auth_key)
      end

      def user_uid
        return nil if @authenticator.kind_of?(Symbol)
        @authenticator
      end

      def error
        return nil if @authenticator.kind_of?(Integer)
        @authenticator
      end

      def nickname
        @nickname
      end

      def auth_key
        @auth_key
      end

      def authenticator
        Services::Authenticator.new
      end

      def ensure_valid_input!(input)
        input.each_pair do |key, value|
          reason = "The given #{key} was blank or missing"

          unless value.kind_of?(String) && !value.empty?
            raise_argument_error(reason, value)
          end
        end
      end

    end
  end
end