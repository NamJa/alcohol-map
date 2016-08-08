class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :place_id,    null: false
      t.integer :score,       null: false
      t.string :ip,           null: false

      t.timestamps null: false
    end
  end
end
