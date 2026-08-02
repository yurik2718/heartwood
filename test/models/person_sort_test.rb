require "test_helper"

class PersonSortTest < ActiveSupport::TestCase
  setup do
    @tree = trees(:alpha)

    @bach   = Person.create!(given_names: "Johann", surname: "Bach",    sex: "M", tree: @tree)
    @handel = Person.create!(given_names: "Georg",  surname: "Handel",  sex: "M", tree: @tree)
    @clara  = Person.create!(given_names: "Clara",  surname: "Schumann", sex: "F", tree: @tree)
    # Force distinct, ordered created_at values — successive Person.create! calls can
    # land on the same timestamp at this precision, which would make created_desc flaky.
    @bach.update_column(:created_at, 3.days.ago)
    @handel.update_column(:created_at, 2.days.ago)
    @clara.update_column(:created_at, 1.day.ago)

    Event.create!(kind: "BIRT", eventable: @bach,   tree: @tree, date_start: Date.new(1685, 3, 31))
    Event.create!(kind: "BIRT", eventable: @handel, tree: @tree, date_start: Date.new(1685, 2, 23))
    # Clara has no recorded birth date on purpose — should sort last either direction.
  end

  test "default falls back to surname_asc" do
    result = @tree.people.sorted("nonsense").to_a
    assert_equal [ @bach, @handel, @clara ], result
  end

  test "surname_asc orders A to Z" do
    result = @tree.people.sorted("surname_asc").to_a
    assert_equal [ @bach, @handel, @clara ], result
  end

  test "surname_desc orders Z to A" do
    result = @tree.people.sorted("surname_desc").to_a
    assert_equal [ @clara, @handel, @bach ], result
  end

  test "birth_asc orders oldest first, undated people last" do
    result = @tree.people.sorted("birth_asc").to_a
    assert_equal [ @handel, @bach, @clara ], result
  end

  test "birth_desc orders newest first, undated people still last" do
    result = @tree.people.sorted("birth_desc").to_a
    assert_equal [ @bach, @handel, @clara ], result
  end

  test "created_desc orders most recently added first" do
    result = @tree.people.sorted("created_desc").to_a
    assert_equal [ @clara, @handel, @bach ], result
  end
end
