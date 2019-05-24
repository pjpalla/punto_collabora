class CreateDrugs < ActiveRecord::Migration
  def change
    create_table :drugs do |t|
      t.text :drug_name
      t.text :category
      t.text :dosage
      t.timestamps null: false
    end
  end
end