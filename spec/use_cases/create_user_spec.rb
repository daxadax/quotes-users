require 'spec_helper'

class CreateUserSpec < UseCaseSpec

  let(:user)      { build_serialized_user }
  let(:use_case)  { UseCases::CreateUser.new(input) }
  let(:input) do
    {
      :nickname => 'nickname',
      :email => 'email',
      :auth_key => 'auth_key'
    }
  end

  describe "call" do
    let(:result)      { use_case.call }
    let(:loaded_user) { gateway.get(result.uid) }

    describe "with unexpected input" do
      describe "without nickname" do
        before { input.delete(:nickname) }

        it "fails" do
          assert_kind_of UseCases::CreateUser::Failure, result
        end
      end

      describe "without email" do
        before { input.delete(:email) }

        it "fails" do
          assert_kind_of UseCases::CreateUser::Failure, result
        end
      end

      describe "without auth_key" do
        before { input.delete(:auth_key) }

        it "fails" do
          assert_kind_of UseCases::CreateUser::Failure, result
        end
      end
    end

    it "builds a new user and saves it to the database" do
      assert_kind_of UseCases::CreateUser::Success, result

      assert_equal 1,           loaded_user.uid
      assert_equal 'nickname',  loaded_user.nickname
      assert_equal 'email',     loaded_user.email
      assert_equal 'auth_key',  loaded_user.auth_key
      assert_empty              loaded_user.favorites
      assert_empty              loaded_user.added
    end

    it "returns the uid of the newly created user on success" do
      assert_equal 1, result.uid
    end

  end
end
