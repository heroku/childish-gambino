class ChangeToUseEncryptionKeys < ActiveRecord::Migration[5.2]
  def change
    change_table :resources do |t|
      t.string :encrypted_access_token
      t.string :encrypted_access_token_iv
      t.string :encrypted_refresh_token
      t.string :encrypted_refresh_token_iv
    end

    remove_column :resources, :access_token
    remove_column :resources, :refresh_token
  end
end
