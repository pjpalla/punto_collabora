class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.integer :uid
      t.string :card

      t.timestamps null: false
    end
  end
end
