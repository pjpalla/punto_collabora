class AddColumnsToIndicator < ActiveRecord::Migration
  def change
    add_column :indicators, :i9, :integer
    add_column :indicators, :i10, :integer
    add_column :indicators, :i11, :integer
  end
end
