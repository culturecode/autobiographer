class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :identifier, :limit => 8
      
      t.string :name
      t.string :place
      t.string :rsvp_status
      t.datetime :start_time
      t.datetime :end_time
      
      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
