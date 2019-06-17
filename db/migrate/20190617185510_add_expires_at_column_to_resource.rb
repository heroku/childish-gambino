class AddExpiresAtColumnToResource < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :access_token_expires_at, :datetime
  end
end
