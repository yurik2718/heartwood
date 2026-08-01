# Adds a relative (parent / child / partner) to a Person, delegating the graph
# wiring to the domain methods on Person. See docs/features/person-profile.md.
class RelativesController < ApplicationController
  # Maps each allowed relation to the domain method that wires it into the
  # graph. Lookups go through this constant so no user input ever reaches
  # public_send as a method name.
  RELATION_METHODS = {
    "parent"  => :add_parent,
    "child"   => :add_child,
    "partner" => :add_partner
  }.freeze

  before_action :set_person
  before_action :set_relation
  before_action :require_can_edit, only: %i[new create]

  def new
    @relative = Person.new
  end

  # Combobox lookup: people in this tree who could be linked as @relation,
  # excluding the focus person and anyone already in that relation.
  def search
    @matches = candidate_people
  end

  def create
    @relative = @person.public_send(RELATION_METHODS.fetch(@relation), relative_source)
    # From the tree's panel the form carries return_to (the tree page) — land back
    # there so the new person appears in the graph. url_from rejects foreign hosts.
    if (return_url = url_from(params[:return_to]))
      redirect_to return_url, notice: t("family.flash.#{@relation}_added")
    else
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @person, notice: t("family.flash.#{@relation}_added") }
      end
    end
  end

  private

  def set_person
    @person = Current.tree.people.find(params[:person_id])
  end

  # Link an existing person (tree-scoped — 404 across tenants) when one is
  # picked from the combobox; otherwise build a new person from the form.
  def relative_source
    if params[:existing_person_id].present?
      Current.tree.people.find(params[:existing_person_id])
    else
      relative_params
    end
  end

  # Guard the relation against the whitelist before any public_send.
  def set_relation
    @relation = params[:relation].to_s
    head :unprocessable_entity unless RELATION_METHODS.key?(@relation)
  end

  def relative_params
    params.expect(person: %i[given_names surname name_prefix name_suffix nickname sex])
  end

  def candidate_people
    query = params[:q].to_s.strip
    return Person.none if query.blank?

    Current.tree.people
           .search(query, user: Current.user)
           .where.not(id: excluded_ids)
           .order(:surname, :given_names)
           .limit(8)
  end

  # The focus person plus anyone already linked in this relation — they should
  # not show up as fresh candidates.
  def excluded_ids
    already = case @relation
    when "parent"  then @person.parents
    when "child"   then @person.children
    when "partner" then @person.partners
    else []
    end
    [ @person.id, *already.map(&:id) ]
  end
end
