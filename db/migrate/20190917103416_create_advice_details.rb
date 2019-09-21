class CreateAdviceDetails < ActiveRecord::Migration
  def change
    create_table :advice_details do |t|
      t.integer :aid
      t.string :choice
      t.string :typology
      t.string :place
      t.string :province
      t.string :topic
      t.string :description
      t.string :keyword
      
      t.timestamps
      
    end
  end
end
