class CreateCheckins < ActiveRecord::Migration
  def self.up
    create_table :checkins do |t|
        t.text :place # Where the event took place
        t.text :comment
        
        t.integer :identifier, :limit => 8
        
        t.timestamps 
    end    
  end

  def self.down
    drop_table :checkins
  end
end
