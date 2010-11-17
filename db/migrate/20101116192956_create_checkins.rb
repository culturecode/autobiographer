class CreateCheckins < ActiveRecord::Migration
  def self.up
    create_table :checkins do |t|
        t.text :place # Where the event took place
        t.text :comment
        
        t.belongs_to :authentication # The service the event was grabbed from
        t.text :identifier # The id of the object on the service        
    end
    
    add_index(:checkins, :authentication_id)
    add_index(:checkins, [:authentication_id, :identifier], :unique => true)
    
  end

  def self.down
    drop_table :checkins
  end
end
