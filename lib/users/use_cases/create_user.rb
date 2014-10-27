require 'bound'

module Users
  module UseCases
    class CreateUser < UseCase

      Success = Bound.required(:uid)
      Failure = Bound.new

      def initialize(input)
        @user = input[:user]
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
        nickname  = user.delete(:nickname)
        email     = user.delete(:email)
        auth_key  = user.delete(:auth_key)
        options   = user

         Entities::User.new(nickname, email, auth_key, options)
      end

      def add_to_gateway(user)
        gateway.add user
      end

      def user
        @user
      end

      def invalid?
        return true if user.nil? || user.empty?

        [user[:nickname], user[:email], user[:auth_key]].each do |required|
           return true if required.nil? || required.empty?
        end
        false
      end

    end
  end
end