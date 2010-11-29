class CreateCheckins < ActiveRecord::Migration
  def self.up
    create_table :checkins do |t|
        t.text :place # Where the event took place
        t.text :comment
        
        t.text :identifier # The id of the object on the service
        
        t.timestamps 
    end    
  end

  def self.down
    drop_table :checkins
  end
end
