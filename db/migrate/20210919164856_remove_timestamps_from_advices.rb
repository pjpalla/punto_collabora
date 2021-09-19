class RemoveTimestampsFromAdvices < ActiveRecord::Migration
  def change
    remove_column :advices, :created_at, :string
    remove_column :advices, :updated_at, :string
  end
end
