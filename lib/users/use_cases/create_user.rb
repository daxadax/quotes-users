require 'bound'

module Users
  module UseCases
    class CreateUser < UseCase

      Success = Bound.required(:uid)
      Failure = Bound.new

      def initialize(input)
        @nickname = input.delete(:nickname)
        @email = input.delete(:email)
        @auth_key = input.delete(:auth_key)
        @options = input
      end

      def call
        return Failure.new if invalid?

        Success.new(:uid => build_user_and_add_to_gateway )
      end

      private

      def build_user_and_add_to_gateway
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
        [nickname, email, auth_key].each do |required|
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
        @auth_key
      end

      def options
        @options
      end

    end
  end
end
