require "application_system_test_case"

# The family-tree canvas (app/javascript/controllers/tree_controller.js) is the one piece
# of hand-written JS in the app. Clicking a node opens the slide-over person panel
# (drawer_controller.js + a turbo-frame); refocusing the tree happens from the panel.
# Server rendering can't prove either, so this drives them in a real browser.
class TreeNavigationTest < ApplicationSystemTestCase
  setup do
    @tree   = trees(:alpha)
    @focus  = Person.create!(given_names: "Focus", surname: "Person", sex: "M", tree: @tree)
    @parent = Person.create!(given_names: "Pat",   surname: "Parent", sex: "F", tree: @tree)
    # Both deceased so nodes render with names + links (living nodes are redacted/linkless).
    Event.create!(kind: "DEAT", eventable: @focus,  tree: @tree)
    Event.create!(kind: "DEAT", eventable: @parent, tree: @tree)

    family = Family.create!(tree: @tree)
    family.children << @focus
    family.partners << @parent

    sign_in_as users(:one)
  end

  test "clicking a node opens the person panel; its tree button refocuses" do
    visit person_tree_path(@focus)
    assert_selector ".tree-node--focus .node-name", text: "Focus"

    # Wait for the Stimulus controller to lay out nodes and draw edges before clicking —
    # before layout, every node is stacked at (0,0) and overlaps the focus node.
    assert_selector ".tree-edges path", wait: 5

    # The canvas applies pan/zoom transforms, so a geometric click can land on an
    # overlapping node; dispatching the click on the exact rendered anchor keeps the
    # test deterministic while still exercising the real turbo-frame load.
    link = find("[data-tree-node-id='#{@parent.id}'] a")
    page.execute_script("arguments[0].click()", link)

    assert_selector ".tree-drawer--open", wait: 5
    assert_selector ".person-panel-name", text: "Pat Parent"

    # The panel's tree button re-centres the whole page on that person.
    find(".person-panel-actions a[href*='/tree']").click
    assert_current_path person_tree_path(@parent), ignore_query: true
    assert_selector ".tree-node--focus .node-name", text: "Pat"
  end

  test "closing the panel empties the frame so the same person can be reopened" do
    visit person_tree_path(@focus)
    assert_selector ".tree-edges path", wait: 5

    link = find("[data-tree-node-id='#{@parent.id}'] a")
    page.execute_script("arguments[0].click()", link)
    assert_selector ".tree-drawer--open", wait: 5

    find(".person-panel-close").click
    assert_no_selector ".tree-drawer--open"
    assert_no_selector ".person-panel-name"

    page.execute_script("arguments[0].click()", link)
    assert_selector ".tree-drawer--open", wait: 5
    assert_selector ".person-panel-name", text: "Pat Parent"
  end
end
