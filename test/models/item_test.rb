require "test_helper"

class ItemTest < ActiveSupport::TestCase
  @pastel = Pastel.new
  # test "the truth" do
  #   assert true
  # end
  #
  test "item price moneitzed" do
    item = Item.new(price: 23.99)
    assert_equal 2399, item.price_cents
  end

  # uses minitest .stub instead of .create to avoid true commits
  test "can get an Item from the database" do
    assert Item.first.present?
  end

  test "can save a new Item to the database" do
    temp = Item.new(
      name: "test",
      description: "test",
      price: 23.99
    )

    assert temp.save
  end

  test "can destroy an item in the database" do
    temp = Item.first
    assert temp.present?

    assert temp.destroy!
  end

  test "can update an item in the database" do
    temp = Item.first
    assert temp.present?

    assert temp.update(name: "test")
  end
end
