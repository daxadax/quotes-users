require 'bound'

module Users
  module Services
    class UserBoundary < Service

      User = Bound.required(
        :uid,
        :nickname,
        :email,
        :favorites,
        :added_quotes,
        :terms_accepted
      )

      def for(user)
        build_boundary(user)
      end

      private

      def build_boundary(user)
        User.new(
          :uid            => user.uid,
          :nickname       => user.nickname,
          :email          => user.email,
          :favorites      => user.favorites,
          :added_quotes   => user.added,
          :terms_accepted => user.terms_accepted?
        )
      end

    end
  end
end