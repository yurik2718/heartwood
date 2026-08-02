class AddEvidenceDepthToCitationsAndSources < ActiveRecord::Migration[8.1]
  def change
    add_column :citations, :page, :string
    add_column :citations, :text, :text
    add_column :citations, :date, :date
    add_column :citations, :confidence, :string, null: false, default: "normal"

    add_column :sources, :author, :string
    add_column :sources, :repository, :string
    add_column :sources, :source_type, :string
  end
end
