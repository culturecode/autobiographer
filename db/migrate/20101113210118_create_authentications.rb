class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table :authentications do |t|
      t.belongs_to :user
      t.string :type
      t.integer :identifier  # Unique identifier for the particular user on the the given service
      t.text :token       # A token used to authenticate the user on the given service (eg. OAuth token)
      t.text :secret      # A secret token used by some services (eg. Foursquare OAuth secret token)
      t.datetime :last_sync
    end
    add_index(:authentications, :user_id)
    add_index(:authentications, :identifier)
  end

  def self.down
    drop_table :authentications
  end
end
