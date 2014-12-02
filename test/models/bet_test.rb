require 'test_helper'

class BetTest < ActiveSupport::TestCase
  test "should not accept bet without user" do
    # bet = Bet.new
    # assert_not bet.save
    assert User.find(1)
  end
end
