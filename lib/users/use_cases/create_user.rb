require 'bound'
require 'bcrypt'

module Users
  module UseCases
    class CreateUser < UseCase

      Result = Bound.required(
        :error,
        :uid
      )

      def initialize(input)
        @nickname = input.delete(:nickname)
        @email = input.delete(:email)
        @auth_key = input.delete(:auth_key)
        @options = input
      end

      def call
        Result.new(:error => error, :uid => build_user_and_add_to_gateway )
      end

      private

      def error
        return :invalid_input if invalid?
        nil
      end

      def build_user_and_add_to_gateway
        return nil if invalid?
        user = build_user
        add_to_gateway user
      end

      def build_user
         Entities::User.new(nickname, email, auth_key, options)
      end

      def add_to_gateway(user)
        gateway.add user
      end

      def invalid?
        [nickname, email, @auth_key].each do |required|
          return true if required.nil? || required.empty?
        end
        false
      end

      def nickname
        @nickname
      end

      def email
        @email
      end

      def auth_key
        BCrypt::Password.create(@auth_key)
      end

      def options
        @options
      end

    end
  end
end
