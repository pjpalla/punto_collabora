class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
      t.integer :uid
      t.text :card
      t.integer :i1
      t.integer :i2
      t.integer :i3
      t.integer :i4
      t.integer :i5
      t.integer :i6
      t.integer :i7
      t.integer :i8

      t.timestamps null: false
    end
  end
end
