class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table :authentications do |t|
      t.belongs_to :user
      t.string :service, :null => false
      t.text :credentials # Any info used to authenticate the user on the given service
    end
  end

  def self.down
    drop_table :authentications
  end
end
