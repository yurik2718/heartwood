require "test_helper"

class TreesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tree   = trees(:alpha)
    @person = Person.create!(given_names: "Johann Sebastian", surname: "Bach", sex: "M", tree: @tree)
    sign_in_as users(:one)
    Current.tree = @tree
  end

  test "GET show renders the ancestors tree by default" do
    get person_tree_url(@person)
    assert_response :success
    assert_select "title", /Bach/
  end

  test "GET show with mode=descendants renders descendants" do
    get person_tree_url(@person, mode: "descendants")
    assert_response :success
    assert_select "[data-tree-mode-value='descendants']"
  end

  test "GET show with mode=ancestors renders ancestors" do
    get person_tree_url(@person, mode: "ancestors")
    assert_response :success
    assert_select "[data-tree-mode-value='ancestors']"
  end

  test "GET show requires authentication" do
    sign_out
    get person_tree_url(@person)
    assert_redirected_to new_session_url
  end

  test "GET show embeds graph JSON on the page" do
    get person_tree_url(@person)
    assert_select "[data-tree-graph-value]"
  end

  test "GET show renders a node for the focus person" do
    get person_tree_url(@person)
    assert_select ".tree-node", minimum: 1
  end

  test "node renders the name on two lines: given names over surname" do
    get person_tree_url(@person)
    assert_select ".tree-node--focus .node-name",    text: "Johann Sebastian"
    assert_select ".tree-node--focus .node-surname", text: "Bach"
  end

  test "GET show with depth param limits the graph depth" do
    parent = Person.create!(sex: "M", tree: @tree)
    fam = Family.create!(tree: @tree)
    fam.partners << parent
    fam.children << @person

    get person_tree_url(@person, depth: 0)
    # depth 0 → only focus person in graph JSON (checked via node count in DOM)
    assert_select ".tree-node", count: 1

    get person_tree_url(@person, depth: 1)
    assert_select ".tree-node", count: 2
  end

  test "mode toggle links preserve current depth" do
    get person_tree_url(@person, mode: "ancestors", depth: 3)
    # The descendants button should carry depth=3
    assert_select "a[href*='mode=descendants'][href*='depth=3']"
  end

  test "depth controls link to incremented and decremented depth" do
    get person_tree_url(@person, mode: "ancestors", depth: 3)
    assert_select "a[href*='depth=2']"
    assert_select "a[href*='depth=4']"
  end

  test "depth control minus is disabled at minimum depth" do
    get person_tree_url(@person, depth: 1)
    assert_select "span.button--disabled", text: "−"
  end

  test "depth control plus is disabled at maximum depth" do
    get person_tree_url(@person, depth: 6)
    assert_select "span.button--disabled", text: "+"
  end

  test "node link loads the person panel into the drawer frame" do
    parent = Person.create!(sex: "M", tree: @tree)
    fam = Family.create!(tree: @tree)
    fam.partners << parent
    fam.children << @person

    get person_tree_url(@person, depth: 1)
    # Nodes open the slide-over panel (turbo-frame), not a full-page navigation.
    assert_select ".tree-node:not(.tree-node--focus) a[href*='/panel'][data-turbo-frame='person-panel']"
  end

  test "descendants view renders the married-in spouse as a couple" do
    spouse = Person.create!(given_names: "Spouse", surname: "Married", sex: "F", tree: @tree)
    child  = Person.create!(given_names: "Kid",    surname: "Bach",    sex: "M", tree: @tree)
    fam = Family.create!(tree: @tree)
    fam.partners << @person << spouse   # spouse married in — not a blood descendant
    fam.children << child

    get person_tree_url(@person, mode: "descendants", depth: 1)
    # The spouse has no blood-descendant path, but the couple model surfaces them.
    assert_select ".tree-node[data-tree-node-id='#{spouse.id}']"
    assert_select "[data-tree-graph-value*='unions']"
  end

  test "renders an add-parent ghost slot for an ancestor without parents" do
    get person_tree_url(@person)   # Bach has no parents recorded
    assert_select ".tree-node--ghost a[href*='/relatives/new'][href*='relation=parent']"
  end

  test "non-focus nodes link to their panel card" do
    child = Person.create!(sex: "F", tree: @tree)
    fam = Family.create!(tree: @tree)
    fam.partners << @person
    fam.children << child

    get person_tree_url(@person, mode: "descendants", depth: 1)
    assert_select ".tree-node:not(.tree-node--focus) a[href*='/panel']"
  end
end
