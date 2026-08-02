class ClanTreesController < ApplicationController
  # The whole-family "родовое древо": a full descendancy from the tree's progenitor.
  # Reuses the descendants layout (couples and all) — see Tree#root_person.
  CLAN_DEPTH = 8

  def show
    @root = Current.tree.root_person
    return unless @root

    @depth   = CLAN_DEPTH
    # No add-relative ghosts on the shared clan landing — it's a viewing surface.
    result   = @root.descendant_graph(depth: @depth, ghosts: false)
    @mode    = result[:mode]
    @graph   = result.except(:persons)
    @persons = result[:persons]
  end
end
