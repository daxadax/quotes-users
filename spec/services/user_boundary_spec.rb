require 'spec_helper'

class UserBoundarySpec < Minitest::Spec
  let(:user)      { build_user }
  let(:boundary)  { Services::UserBoundary.new }
  let(:result)    { boundary.for(user) }

  it "grants access to uid" do
    assert_equal user.uid, result.uid
  end

  it "grants access to nickname" do
    assert_equal user.nickname,  result.nickname
  end

  it "grants access to email" do
    assert_equal user.email, result.email
  end

  it "grants access to favorites" do
    assert_equal user.favorites, result.favorites
  end

  it "grants access to added_quotes" do
    assert_equal user.added, result.added_quotes
  end

  it "grants access to terms_accepted" do
    assert_equal user.terms_accepted?,  result.terms_accepted
  end
end