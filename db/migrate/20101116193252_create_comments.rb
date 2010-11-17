class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :text
      t.timestamps
      
      t.belongs_to :authentication # The service the event was grabbed from
      t.text :identifier # The id of the object on the service      
    end
    
    add_index(:comments, :authentication_id)
    add_index(:comments, [:authentication_id, :identifier], :unique => true)
    
  end

  def self.down
    drop_table :comments
  end
end
