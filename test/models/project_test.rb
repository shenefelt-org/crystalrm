require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "should create a new project" do
    project = projects(:one)

    assert_not_nil project.customer
    assert_not_nil project.user
    assert_not_nil project.name
  end

  test "should update project name" do
    project = projects(:one)
    assert project.update(name: "new test")
  end
end
