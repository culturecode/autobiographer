class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.belongs_to :user

      t.datetime :timestamp, :null => false # When the event took place
      t.text :place, :null => false # Where the event took place

      t.belongs_to :service # The service the event was grabbed from
      t.text :identifier # The id of the object on the service
    end
  end

  def self.down
    drop_table :events
  end
end
