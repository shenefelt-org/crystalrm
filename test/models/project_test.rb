require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "should create a new project" do
    project = projects(:one)

    assert_not_nil project.customer
    assert_not_nil project.user
    assert_not_nil project.name
  end


end
