require 'bound'

module Users
  module UseCases
    class PublishQuote < UseCase

      Result = Bound.new(:error, :uid)

      def initialize(input)
        ensure_valid_input!(input)

        @uid = input[:uid]
        @quote_uid = input[:quote_uid]
        @error = nil
      end

      def call
        user = gateway.get(uid)
        return failure(:user_not_found) unless user

        Result.new(:error => nil, :uid => publish_quote )
      end

      private

      def failure(error)
        Result.new(:error => error, :uid => nil)
      end

      def publish_quote
        gateway.publish_quote uid, quote_uid
      end
      
      def error
          @error
      end

      def uid
        @uid
      end

      def quote_uid
        @quote_uid
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
