# require 'spec_helper'

# class GetQuotesSpec < UseCaseSpec
#   let(:use_case)  { UseCases::GetQuotes.new }

#   describe "call" do
#     let(:result)        { use_case.call }
#     let(:first_result)  { result.quotes.first }

#     describe "with no quotes in the db" do
#       let(:quotes) { nil }

#       it "returns an empty array" do
#         assert_empty  result.quotes
#       end
#     end

#     describe "with 50 quotes in the db" do
#       before do
#         50.times { create_quote }
#       end

#       it "retrieves all quotes from the backend in the form of bound objects" do
#         assert_equal   50,                              result.quotes.size
#         assert_kind_of UseCases::GetQuotes::Result,     result
#         assert_kind_of Services::QuoteBoundary::Quote,  first_result

#         assert_equal 1,         first_result.id
#         assert_equal 'Author',  first_result.author
#         assert_equal 'Title',   first_result.title
#         assert_equal 'Content', first_result.content
#       end
#     end
#   end

# end