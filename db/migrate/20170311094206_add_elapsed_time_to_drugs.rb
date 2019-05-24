class AddElapsedTimeToDrugs < ActiveRecord::Migration
  def change
    add_column :drugs, :elapsed_time, :string
  end
end
