class CreateWearablesTable < ActiveRecord::Migration
  def change
    create_table :wearables do |t|
      t.string :clothing
      t.string :body_part
      t.string :temperature
      t.string :gender
    end
  end
end
