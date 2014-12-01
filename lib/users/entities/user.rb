module Users
  module Entities
    class User < Entity
      attr_reader :uid,
        :nickname,
        :email,
        :auth_key,
        :added,
        :favorites,
        :last_login_time,
        :last_login_address,
        :login_count

      def initialize(nickname, email, auth_key, options = {})
        ensure_valid_input!(nickname, email, auth_key)

        @nickname = nickname
        @email = email
        @auth_key = auth_key
        @uid = options[:uid] || nil
        @favorites = options[:favorites] || []
        @added = options[:added] || Hash.new { |h,k| h[k] = [] }
        @terms = options[:terms] || false
        @last_login_time = options[:last_login_time] || nil
        @last_login_address = options[:last_login_address] || nil
        @login_count = options[:login_count] || 0
      end

      def update(updates)
        update_user_values(updates)
        self
      end

      def terms_accepted?
        @terms
      end

      def added_quotes
        @added[:quotes] || []
      end

      def added_publications
        @added[:publications]
      end

      private

      def update_user_values(updates)
        updates.each do |attribute, updated_value|
          self.instance_variable_set "@#{attribute}", updated_value
        end
      end

      def ensure_valid_input!(nickname, email, auth_key)
        msg = 'Missing required input'

        raise_argument_error(msg, :nickname) if nickname.nil? || nickname.empty?
        raise_argument_error(msg, :email) if email.nil? || email.empty?
        raise_argument_error(msg, :auth_key) if auth_key.nil? || auth_key.empty?
      end

    end
  end
end
