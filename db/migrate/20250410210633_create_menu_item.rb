class CreateMenuItem < ActiveRecord::Migration[7.2]
  def change
    create_table :menu_items do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.references :menu, null: false, foreign_key: true

      t.timestamps
    end
  end
end
