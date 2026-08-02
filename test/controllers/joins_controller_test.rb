require "test_helper"

# GET/POST /join/:join_code — see [[collaboration]].
class JoinsControllerTest < ActionDispatch::IntegrationTest
  setup { @tree = trees(:beta) }

  test "unauthenticated visitor is bounced to sign-in and lands back on the join page" do
    get join_url(@tree.join_code)
    assert_redirected_to new_session_url

    user = User.create!(name: "Newcomer", email_address: "newcomer@example.com", password: "password")
    post session_url, params: { email_address: user.email_address, password: "password" }
    follow_redirect!
    assert_response :success
    assert_match(@tree.name, @response.body)
  end

  test "a brand-new visitor can register through the join link and gets added as editor" do
    get join_url(@tree.join_code)
    post registration_url, params: {
      user: { name: "Fresh Signup", email_address: "fresh@example.com", password: "password123" }
    }
    follow_redirect!
    assert_response :success

    post join_path(@tree.join_code)
    assert_redirected_to root_url

    user = User.find_by(email_address: "fresh@example.com")
    assert user.tree_memberships.exists?(tree: @tree, role: "editor")
  end

  test "an existing user with their own tree can sign in and join a second one" do
    owner = users(:one) # already owns trees(:alpha)
    get join_url(@tree.join_code)
    post session_url, params: { email_address: owner.email_address, password: "password" }
    follow_redirect!

    assert_difference "owner.tree_memberships.count", 1 do
      post join_path(@tree.join_code)
    end
    assert_redirected_to root_url
    assert owner.tree_memberships.exists?(tree: @tree, role: "editor")
    # still a member of their own tree too
    assert owner.tree_memberships.exists?(tree: trees(:alpha), role: "owner")
  end

  test "already a member gets redirected with a notice instead of the confirm page" do
    post session_url, params: { email_address: users(:one).email_address, password: "password" }
    get join_url(trees(:alpha).join_code)
    assert_redirected_to root_url
  end

  test "joining switches the active tree" do
    owner = users(:one)
    post session_url, params: { email_address: owner.email_address, password: "password" }
    post join_path(@tree.join_code)

    get people_url
    assert_match(@tree.name, @response.body)
  end

  test "unknown join code 404s" do
    post session_url, params: { email_address: users(:one).email_address, password: "password" }
    get join_url("NOPE-0000-CODE")
    assert_response :not_found
  end
end
