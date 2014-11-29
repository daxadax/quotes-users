module Users
  module Gateways
    class UserGateway < Gateway

      def initialize(backend = nil)
        @backend = backend || backend_for_users
      end

       def add(user)
        ensure_valid!(user)

        @backend.insert(serialized(user))
      end

      def get(uid)
        deserialize(@backend.get(uid))
      end

      def fetch(nickname)
        deserialize(@backend.fetch(nickname))
      end

      def update(user)
        ensure_persisted!(user.uid, 'update')

        @backend.update(serialized(user))
      end

      def publish_quote(uid, quote_uid)
        user = get(uid)
        raise_argument_error('no user found', uid) unless user
        user.added << quote_uid

        @backend.update(serialized(user))
      end

      def all
        @backend.all.map do |user|
          deserialize(user)
        end
      end

      def delete(uid)
        ensure_persisted!(uid, 'delete')

        @backend.delete(uid)
      end

      def toggle_favorite(uid, quote_uid)
        ensure_persisted!(uid, "favorite quote ##{quote_uid} for" )
        user = get(uid)

        toggle_favorite_for(user, quote_uid)
        update user
      end

      private

      def toggle_favorite_for(user, quote_uid)
        if user.favorites.include?(quote_uid)
          user.favorites.delete(quote_uid)
        else
          user.favorites << quote_uid
        end
      end

      def serialized(user)
        UserMarshal.dump(user)
      end

      def deserialize(user)
        UserMarshal.load(user)
      end

      def ensure_valid!(user)
        ensure_kind_of!(user)
        ensure_not_persisted!(user)
      end

      def ensure_kind_of!(user)
        reason = "Only User entities can be added"

        unless user.kind_of? Entities::User
          raise_argument_error(reason, user)
        end
      end

      def ensure_not_persisted!(user)
        reason = "Users can't be added twice. Use #update instead"

        raise_argument_error(reason, user) unless user.uid.nil?
      end

      def ensure_persisted!(uid, action)
        reason = "You tried to #{action} a user, but it doesn't exist"

        raise_argument_error(reason, 'None. UID is nil') if uid.nil?
      end

      class UserMarshal

        def self.dump(user)
          {
            :uid => user.uid,
            :nickname => user.nickname,
            :email => user.email,
            :auth_key => user.auth_key,
            :terms => user.terms_accepted?,
            :favorites => JSON.dump(user.favorites),
            :added => JSON.dump(user.added),
            :last_login_time => user.last_login_time,
            :last_login_address => user.last_login_address,
            :login_count => user.login_count
          }
        end

        def self.load(user)
          return nil unless user

          nickname  = user[:nickname]
          email     = user[:email]
          auth_key  = user[:auth_key]
          options   = {
            :uid => user[:uid],
            :terms => user[:terms] == '1' ? true : false,
            :favorites => JSON.parse(user[:favorites]),
            :added => JSON.parse(user[:added]),
            :last_login_time => user[:last_login_time],
            :last_login_address => user[:last_login_address],
            :login_count => user[:login_count]
          }

          Entities::User.new(nickname, email, auth_key, options)
        end

      end
    end
  end
end
