require "test_helper"

# The invite-link mechanic — once-campfire's join_code, adapted per-tree. See
# [[collaboration]].
class TreeJoinCodeTest < ActiveSupport::TestCase
  test "a join code is generated automatically on create" do
    tree = Tree.create!(name: "Fresh Tree")
    assert tree.join_code.present?
  end

  test "join codes are unique" do
    other = Tree.create!(name: "Other")
    dup = Tree.new(name: "Dup", join_code: other.join_code)
    assert_not dup.valid?
    assert dup.errors[:join_code].any?
  end

  test "reset_join_code! swaps in a new code, invalidating the old one" do
    tree = Tree.create!(name: "Fresh Tree")
    old_code = tree.join_code
    tree.reset_join_code!
    assert_not_equal old_code, tree.join_code
    assert_nil Tree.find_by(join_code: old_code)
  end

  test "fixture trees already have a join code (backfilled by the migration)" do
    assert trees(:alpha).join_code.present?
    assert trees(:beta).join_code.present?
    assert_not_equal trees(:alpha).join_code, trees(:beta).join_code
  end
end
