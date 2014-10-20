module Users
  module Entities
    class User < Entity
      attr_reader :uid,
                  :nickname,
                  :email,
                  :auth_key,
                  :favorites,
                  :added

      def initialize(nickname, email, auth_key, options = {})
        ensure_valid_input!(nickname, email, auth_key)

        @nickname   = nickname
        @email      = email
        @auth_key   = auth_key
        @uid        = options[:uid]       || nil
        @favorites  = options[:favorites] || []
        @added      = options[:added]     || []
        @terms      = options[:terms]     || false
      end

      def terms_accepted?
        @terms
      end

      private

      def ensure_valid_input!(nickname, email, auth_key)
        msg = 'Missing required input'

        raise_argument_error(msg, :nickname) if nickname.nil? || nickname.empty?
        raise_argument_error(msg, :email)    if email.nil?    || email.empty?
        raise_argument_error(msg, :auth_key) if auth_key.nil? || auth_key.empty?
      end

    end
  end
end