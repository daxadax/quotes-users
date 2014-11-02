require 'spec_helper'

class AuthenticatorSpec < Minitest::Spec
  let(:nickname)      { 'nickname' }
  let(:auth_key)      { 'auth_key' }
  let(:fake_gateway)  { FakeGateway.new }
  let(:authenticator) { Services::Authenticator.new(fake_gateway) }
  let(:result)        { authenticator.for(nickname, auth_key) }

  describe "no matching user is found" do
    let(:nickname) { 'unknown_user' }

    it "returns an error key but no user" do
      assert_equal :user_not_found, result
    end
  end

  describe "matching user is found" do
    before do
      fake_gateway.add_user('nickname', 'auth_key')
    end

    describe "auth_key does not match" do
      let(:auth_key) { 'wrong key' }

      it "returns an error key but no user" do
        assert_equal :auth_failure, result
      end
    end

    it "returns the user's uid" do
      assert_equal 'nickname_uid', result
    end
  end

  class FakeGateway
    def initialize
      @memory = Hash.new { |hash, key| hash[key] = {} }
    end

    def add_user(nickname, auth_key)
      @memory[nickname] = OpenStruct.new(
        :uid      => "#{nickname}_uid",
        :auth_key => auth_key
      )
    end

    def fetch(nickname)
      return nil if @memory[nickname].empty?

      @memory[nickname]
    end
  end
end
