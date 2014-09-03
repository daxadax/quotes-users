module Support
  module FactoryHelpers

    def build_user(opts = {})
      Users::Entities::User.new('nickname', 'email', 'password', :private, opts)
    end

  end
end