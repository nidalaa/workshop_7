class ChangePasswordColumnName < ActiveRecord::Migration
  def self.up
    rename_column :users, :password, :encrypted_password
  end
end
