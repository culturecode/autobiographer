class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.datetime :timestamp # When the event took place
      t.integer :offset, :null => false, :default => 0 # The order the events should appear in if more than one event has the same timestamp

      t.integer :details_id
      t.string :details_type
      
      t.belongs_to :user
    end
    
    add_index(:events, :timestamp) # For ordering
    add_index(:events, [:details_id, :details_type]) # For lookups from the details object
    add_index(:events, :user_id) # For grabbing all events for a particular user
    
  end

  def self.down
    drop_table :events
  end
end
