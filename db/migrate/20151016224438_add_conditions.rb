class AddConditions < ActiveRecord::Migration
  def change

    add_column :wearables, :conditions, :integer
  end
end
