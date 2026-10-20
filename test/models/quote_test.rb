require "test_helper"

class QuoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should create quote" do
    quote = quotes(:one)
    assert_equal customers(:one), quote.customer
  end
end
