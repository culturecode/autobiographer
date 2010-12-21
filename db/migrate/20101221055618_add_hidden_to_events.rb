class AddHiddenToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :hidden, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :events, :hidden
  end
end
