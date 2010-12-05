class MakeNotesPolymorphic < ActiveRecord::Migration
  def self.up
    add_column :notes, :notable_id, :integer
    add_column :notes, :notable_type, :string
    Note.destroy_all # Remove all notes because we don't know where to attach them
  end

  def self.down
    raise "Can't reverse this migration"
  end
end
