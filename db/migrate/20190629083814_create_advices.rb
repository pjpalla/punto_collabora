class CreateAdvices < ActiveRecord::Migration
  def change
    create_table :advices do |t|
      t.integer :uid

      t.timestamps null: false
    end
  end
end
