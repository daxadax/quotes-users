require 'spec_helper'

class UserSpec < Minitest::Spec

  let(:nickname)  { 'joe' }
  let(:email)     { 'joe@mail.com' }
  let(:password)  { 'secret' }
  let(:privacy)   { :none }
  let(:options)   { {} }
  let(:user)      { build_user(nickname, email, password, privacy, options) }

  describe 'construction' do
    it 'can be built with four arguments' do
      assert_equal 'joe',           user.nickname
      assert_equal 'joe@mail.com',  user.email
      assert_equal 'secret',        user.password
      assert_equal :none,           user.privacy
    end

    it "has sane defaults for non-required arguments" do
      assert_nil    user.uid
      assert_empty  user.favorites
      assert_empty  user.added
      assert_equal  false, user.terms_accepted?
    end

    it "fails without required arguments" do
      assert_failure { build_user(nil,      email,  password) }
      assert_failure { build_user(nickname, nil,    password) }
      assert_failure { build_user(nickname, email,  nil)      }
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
        assert_equal 'joe',           user.nickname
        assert_equal 'joe@mail.com',  user.email
        assert_equal 'secret',        user.password
        assert_equal :none,           user.privacy
        assert_equal 1,               user.uid
        assert_equal 3,               user.favorites.size
        assert_equal [23, 52, 99],    user.favorites
        assert_equal 1,               user.added.size
        assert_equal [23],            user.added
        assert_equal true,            user.terms_accepted?
      end
    end
  end

  def build_user(nickname, email, password, privacy, options)
    Entities::User.new(nickname, email, password, privacy, options)
  end

end