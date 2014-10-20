require 'spec_helper'

class UserGatewaySpec < Minitest::Spec

  let(:backend)   { FakeBackend.new }
  let(:gateway)   { Gateways::UserGateway.new(backend) }
  let(:user)      { build_user }

  let(:updated_user) do
    build_user(
      :uid         => 1,
      :terms      => true,
      :favorites  => [23, 410],
      :added      => [23]
    )
  end
  let(:add_user) { gateway.add(user) }

  describe "add" do
    it "ensures the added object is a User Entity" do
      assert_failure { gateway.add(23) }
    end

    describe "with an already added user" do
      let(:user) { build_user(:uid => 1) }

      it "fails" do
        assert_failure { gateway.add(user) }
      end
    end

    it "returns the id of the inserted quote on success" do
      user_uid = add_user

      assert_equal 'test_user_uid', user_uid
    end

    it "serializes the user and delegates it to the backend" do
      user_uid  = add_user
      result    = gateway.get(user_uid)

      assert_equal result.nickname, user.nickname
      assert_equal result.email,    user.email
      assert_equal result.auth_key, user.auth_key
      assert_empty result.favorites
      assert_empty result.added
      assert_equal false,           result.terms_accepted?
    end
  end

  describe "get" do
    it "returns nil if the backend returns nil" do
      assert_nil gateway.get('not_a_stored_id')
    end
  end

  describe "update" do

    describe "without a persisted object" do
      it "fails" do
        assert_failure { gateway.update(user) }
      end
    end

  it "updates any changed attributes" do
    user_uid = add_user
    gateway.update(updated_user)
    result = gateway.get(updated_user.uid)

    refute_equal user,          result
    assert_equal 1,             result.uid
    assert_equal user.nickname, result.nickname
    assert_equal user.email,    result.email
    assert_equal user.auth_key, result.auth_key
    assert_equal true,          result.terms_accepted?
    assert_equal [23, 410],     result.favorites
    assert_equal [23],          result.added
  end

  end

  describe "all" do
    let(:user_two)   { Entities::User.new('2', '2', '2') }
    let(:user_three) { Entities::User.new('3', '3', '3') }
    let(:users)      { [user, user_two, user_three] }

    it "returns an empty array if the backend is empty" do
      assert_empty gateway.all
    end

    it "returns all items in the backend" do
      users.each {|user| gateway.add(user)}
      result = gateway.all

      assert_equal 3,           result.size
      assert_equal "nickname",  result[0].nickname
      assert_equal "2",         result[1].nickname
      assert_equal "3",         result[2].nickname
    end
  end

  describe "delete" do
    describe "without a persisted object" do
      it "fails" do
        assert_failure { gateway.delete(user.uid) }
      end
    end

    it "removes the user associated with the given uid" do
      uid = gateway.add(user)
      gateway.delete(uid)

      assert_nil gateway.get(uid)
    end
  end

  describe "toggle_favorite" do
    describe "without a persisted user" do
      it "fails" do
        assert_failure { gateway.toggle_favorite(user.uid, '23') }
      end
    end

    it "adds or removes a quote uid to/from the user's favorites" do
      uid       = gateway.add(user)
      quote_uid = '23'

      user = gateway.get(uid)
      assert_equal false, user.favorites.include?(quote_uid)

      gateway.toggle_favorite(uid, quote_uid)
      user = gateway.get(uid)
      assert_equal true, user.favorites.include?(quote_uid)

      gateway.toggle_favorite(uid, quote_uid)
      user = gateway.get(uid)
      assert_equal false, user.favorites.include?(quote_uid)
    end
  end

  class FakeBackend

    def initialize
      @memory = []
    end

    def insert(user)
      user[:uid] = 'test_user_uid'

      @memory << user

      user[:uid]
    end

    def get(uid)
      @memory.select{ |u| u[:uid] == uid}.first
    end

    def update(user)
      @memory.delete_if {|u| u[:uid] == user[:uid]}
      @memory << user
    end

    def all
      @memory
    end

    def delete(uid)
      @memory.delete_if {|u| u[:uid] == uid}
    end

  end
end











