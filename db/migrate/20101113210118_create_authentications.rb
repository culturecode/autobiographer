class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table :authentications do |t|
      t.belongs_to :user
      t.string :type
      t.text :identifier  # Unique identifier for the particular user on the the given service
      t.text :credentials # Any info used to authenticate the user on the given service (eg. OAuth token)
      t.datetime :last_sync
    end
    add_index(:authentications, :user_id)
    add_index(:authentications, :identifier)
  end

  def self.down
    drop_table :authentications
  end
end
