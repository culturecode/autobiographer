class CreateDiscussions < ActiveRecord::Migration
  def self.up
    create_table :discussions do |t|
      t.text :subject
      t.text :messages
      t.integer :identifier, :limit => 8      
      t.timestamps
    end
  end

  def self.down
    drop_table :discussions
  end
end
