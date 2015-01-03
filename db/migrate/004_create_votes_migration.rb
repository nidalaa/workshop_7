class CreateVotesMigration < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.column :story_id, :integer
      t.column :user_id, :integer
      t.column :point, :integer
    end
  end
 
  def self.down
    drop_table :votes
  end
end
