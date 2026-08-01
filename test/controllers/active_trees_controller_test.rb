require "test_helper"

# Switching which tree is active for this session. See [[collaboration]].
class ActiveTreesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) # owns trees(:alpha)
    TreeMembership.create!(user: @user, tree: trees(:beta), role: "editor")
    post session_url, params: { email_address: @user.email_address, password: "password" }
  end

  test "switches to a tree the user belongs to" do
    patch active_tree_url(tree_id: trees(:beta).id)
    assert_redirected_to root_url
    follow_redirect!
    assert_match(/Beta Tree/, @response.body)
  end

  test "the switch persists across requests" do
    patch active_tree_url(tree_id: trees(:beta).id)
    get people_url
    assert_match(/Beta Tree/, @response.body)
  end

  test "rejects switching to a tree the user does not belong to" do
    other = Tree.create!(name: "Not Mine")
    patch active_tree_url(tree_id: other.id)
    assert_redirected_to root_url
    follow_redirect!
    assert_select ".flash--alert", text: I18n.t("active_tree.flash.not_a_member")
  end
end
