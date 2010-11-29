class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :file
      
      t.belongs_to :photo_group
      
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
