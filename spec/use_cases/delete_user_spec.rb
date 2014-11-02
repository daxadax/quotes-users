require 'spec_helper'

class DeleteUserSpec < UseCaseSpec

  let(:uid) { gateway.all.last.uid }
  let(:input) { {:uid => uid} }
  let(:use_case) { UseCases::DeleteUser.new(input) }
  let(:result) {  use_case.call }

  describe "call" do
    before { 5.times { create_user } }

    it "deletes the user with the given uid" do
      assert_equal 5, gateway.all.count

      use_case.call

      assert_equal 4, gateway.all.count
      assert_nil gateway.get(uid)
    end
  end
end
