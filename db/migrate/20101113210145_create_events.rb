class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.datetime :timestamp # When the event took place
      t.text :place # Where the event took place
      t.text :comment

      t.belongs_to :authentication # The service the event was grabbed from
      t.text :identifier # The id of the object on the service
    end
    
    add_index(:events, :timestamp) # For ordering
    add_index(:events, :authentication_id)
    add_index(:events, :place) # For searching
  end

  def self.down
    drop_table :events
  end
end
