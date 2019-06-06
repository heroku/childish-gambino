class AddStateToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :state, :string
  end
end
