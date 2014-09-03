module Users
  module Entities
    class User < Entity
      attr_reader :uid,
                  :nickname,
                  :email,
                  :password,
                  :privacy,
                  :favorites,
                  :added

      def initialize(nickname, email, password, privacy, options = {})
        ensure_valid_input!(nickname, email, password, privacy)

        @nickname   = nickname
        @email      = email
        @password   = password
        @privacy    = privacy
        @uid        = options[:uid]       || nil
        @favorites  = options[:favorites] || []
        @added      = options[:added]     || []
        @terms      = options[:terms]     || false
      end

      def terms_accepted?
        @terms
      end

      private

      def ensure_valid_input!(nickname, email, password, privacy)
        msg = 'Missing required input'

        raise_argument_error(msg, :nickname) if nickname.nil? || nickname.empty?
        raise_argument_error(msg, :email)    if email.nil?    || email.empty?
        raise_argument_error(msg, :password) if password.nil? || password.empty?
        raise_argument_error(msg, :privacy)  if privacy.nil?  || privacy.empty?
      end

    end
  end
end