class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :patient_id
      t.string :collection_point
      t.string :collection_point_name
      t.string :collection_point_address
      t.timestamps null: false
    end
  end
end
