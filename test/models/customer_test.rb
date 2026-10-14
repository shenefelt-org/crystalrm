require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  
  test "can create a customer in the database" do
    temp = Customer.new(first_name: "test", last_name: "test", email: "test@test.com")
    assert temp.save
  end

  test "can update a customer in the database" do
    temp = Customer.new(first_name: "test", last_name: "test", email: "test@test.com")
    assert temp.save

    assert temp.update!(first_name: "test2")
  end

  test "should get full name from first and last name fields" do
    temp = Customer.new(first_name: "test", last_name: "test", email: "test@test.com")
    assert temp.save

    assert_equal "#{temp.first_name} #{temp.last_name}", temp.full_name
  end

  test "customer can be assigned a project" do
    customer = customers(:one)
    user = users(:one)

    assert customer.projects.create!(
      name: "test",
      description: "test",
      customer_id: customer.id,
      user_id: user.id,
      project_value: 23.99
    )
  end




end
