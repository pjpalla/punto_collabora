class AddColumnsToDrugs < ActiveRecord::Migration
  def change
    add_column :drugs, :effect, :string
    add_column :drugs, :sex, :string, :limit => 1
    add_column :drugs, :age_range, :string
  end
end
