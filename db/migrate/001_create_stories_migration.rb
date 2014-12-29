class CreateStoriesMigration < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.column :title, :string
      t.column :url, :string
    end
  end
 
  def self.down
    drop_table :stories
  end
end
