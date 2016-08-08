class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :category,   null: false
      t.string :latitude,   null: false
      t.string :longitude,  null: false
      t.string :placename,  null: false
      t.string :address,    null: false
      t.string :website,    null: false
      t.text :content,      default: ""
      t.integer :rating,    default: 0
      t.integer :rating_count, defalut: 0

      t.timestamps null: false
    end
  end
end
