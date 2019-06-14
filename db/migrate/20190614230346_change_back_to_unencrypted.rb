class ChangeBackToUnencrypted < ActiveRecord::Migration[5.2]
  def change
    change_table :resources do |t|
      t.string :refresh_token
      t.string :access_token
    end

    remove_column :resources, :encrypted_access_token
    remove_column :resources, :encrypted_access_token_iv
    remove_column :resources, :encrypted_refresh_token
    remove_column :resources, :encrypted_refresh_token_iv
  end
end
