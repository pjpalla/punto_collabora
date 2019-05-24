class CreateBrandNameDrugs < ActiveRecord::Migration
  def change
    create_table :brand_name_drugs do |t|
      t.text :drug_name
      t.text :category
      t.text :dosage
      t.text :effect
      t.text :sex
      t.text :age_range
      t.text :elapsed_time      
      t.timestamps null: false
    end
  end
end
