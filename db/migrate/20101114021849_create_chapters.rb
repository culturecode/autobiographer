class CreateChapters < ActiveRecord::Migration
  def self.up
    create_table :chapters do |t|
      t.belongs_to :user
      t.string :title
      t.text :subtitle
      t.datetime :timestamp
    end
    
    add_index :chapters, :timestamp # for ordering
  end

  def self.down
    drop_table :chapters
  end
end
