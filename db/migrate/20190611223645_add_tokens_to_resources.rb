class AddTokensToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :access_token, :string
    add_column :resources, :refresh_token, :string
  end
end
