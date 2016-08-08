class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :category,   null: false
      t.string :placename,  null: false
      t.string :address,    null: false
      t.string :website,    null: false

      t.timestamps null: false
    end
  end
end
