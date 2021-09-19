class RemoveTimestampsFromAdviceDetails < ActiveRecord::Migration
  def change
    remove_column :advice_details, :created_at, :string
    remove_column :advice_details, :updated_at, :string
  end
end
