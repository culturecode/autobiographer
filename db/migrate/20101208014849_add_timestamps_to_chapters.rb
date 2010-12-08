class AddTimestampsToChapters < ActiveRecord::Migration
  def self.up
    add_timestamps :chapters
  end

  def self.down
    remove_timestamps :chapters
  end
end
