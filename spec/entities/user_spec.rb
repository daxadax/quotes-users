require 'spec_helper'

class UserSpec < Minitest::Spec
  let(:options)   { {} }
  let(:user)      { build_user(options) }

  describe 'construction' do
    it 'can be built with four arguments' do
      assert_equal 'nickname',  user.nickname
      assert_equal 'email',     user.email
      assert_equal 'auth_key',  user.auth_key
    end

    it "has sane defaults for non-required arguments" do
      assert_nil    user.uid
      assert_empty  user.favorites
      assert_empty  user.added
      assert_equal  false, user.terms_accepted?
    end

    it "fails without required arguments" do
      assert_failure { Entities::User.new(nil,    'email', 'auth_key' ) }
      assert_failure { Entities::User.new('name', nil,     'auth_key' ) }
      assert_failure { Entities::User.new('name', 'email', nil    ) }
    end

    describe "with options" do
      let(:options) do
        {
          :uid        => 1,
          :favorites  => [23, 52, 99],
          :added      => [23],
          :terms      => true
        }
      end

      it "builds users with details from the options hash if present" do
        assert_equal 'nickname',    user.nickname
        assert_equal 'email',       user.email
        assert_equal 'auth_key',    user.auth_key
        assert_equal 1,             user.uid
        assert_equal 3,             user.favorites.size
        assert_equal [23, 52, 99],  user.favorites
        assert_equal 1,             user.added.size
        assert_equal [23],          user.added
        assert_equal true,          user.terms_accepted?
      end
    end
  end

end