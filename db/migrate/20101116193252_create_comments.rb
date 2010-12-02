class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :text
      
      t.timestamps
      
      t.integer :identifier, :limit => 8
    end
  end

  def self.down
    drop_table :comments
  end
end
