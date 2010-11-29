class CreatePhotoGroups < ActiveRecord::Migration
  def self.up
    create_table :photo_groups do |t|
      t.belongs_to :authentication # The service the event was grabbed from
      
      t.timestamps
    end
  end

  def self.down
    drop_table :photo_groups
  end
end
