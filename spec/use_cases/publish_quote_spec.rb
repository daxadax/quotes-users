require 'spec_helper'

class PublishQuoteSpec < UseCaseSpec
  let(:input) do
    {
      :uid => nil,
      :quote_uid => 99
    }
  end
  let(:use_case) do
    UseCases::PublishQuote.new(input)
  end
  let(:publish_quote) { use_case.call }

  describe "call" do

    describe "with an unpersisted user" do
      before do
        user_uid = create_user.uid
        input[:uid] = user_uid + 23
      end

      it "returns an error message, but does not update anything" do
        result = publish_quote

        assert_equal  :user_not_found, result.error
      end
    end

    describe "with correct input and a persisted user" do

      it "publishes the quote for the given user" do
        user_uid = create_user.uid
        input[:uid] = user_uid
        publish_quote
        user = gateway.get(user_uid)

        assert_includes user.added, input[:quote_uid]
      end
    end

  end

end
