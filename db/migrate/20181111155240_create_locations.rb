class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.integer :lo_number
      t.string :lo_name
      t.string :lo_type
      
      t.timestamps
    end
  end
end
