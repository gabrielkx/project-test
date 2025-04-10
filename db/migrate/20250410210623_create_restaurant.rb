class CreateRestaurant < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurants do |t|
      t.name
      t.timestamps
    end
  end
end
