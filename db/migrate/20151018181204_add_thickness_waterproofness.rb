class AddThicknessWaterproofness < ActiveRecord::Migration
  def change
    add_column :wearables, :thickness, :integer
    add_column :wearables, :waterproofness, :integer
  end
end
