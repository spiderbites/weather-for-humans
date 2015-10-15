class CreateWearableTable < ActiveRecord::Migration
  def change
    create_table :Wearable do |t|
      t.string :clothing
      t.string :body_part
      t.integer :min_temp
      t.integer :max_temp
      t.string :gender
    end
  end
end
