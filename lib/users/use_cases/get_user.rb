require 'users/services/user_boundary'

module Users
  module UseCases
    class GetUser < UseCase

      User    = Services::UserBoundary::User
      Result  = Bound.required( :user => User )

      def initialize(input)
        ensure_valid_input!(input[:uid])

        @uid = input[:uid]
      end

      def call
        Result.new(:user => get_user)
      end

      private

      def get_user
        user = gateway.get(@uid)

        user_boundary.for user
      end

      def ensure_valid_input!(uid)
        reason = "The given User UID is invalid"

        unless uid.kind_of? Integer || uid.nil?
          raise_argument_error(reason, uid)
        end
      end

    end
  end
end