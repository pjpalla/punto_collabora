class CreateIndicatorDescription < ActiveRecord::Migration
  def change
    create_table :indicator_descriptions do |t|
      t.string :name
      t.text :description
    end
  end
end
