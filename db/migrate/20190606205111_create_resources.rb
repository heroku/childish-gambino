class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.string :plan
      t.string :region
      t.string :oauth_grant_code
      t.string :heroku_uuid
      t.string :oauth_grant_type
      t.string :oauth_grant_expires_at

      t.timestamps
    end
  end
end
