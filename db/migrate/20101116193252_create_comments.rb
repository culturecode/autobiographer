class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :text
      t.timestamps
      
      t.text :identifier # The id of the object on the service      
    end
  end

  def self.down
    drop_table :comments
  end
end
