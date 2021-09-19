class RemoveTimestampsFromTopicDescriptions < ActiveRecord::Migration
  def change
    remove_column :topic_descriptions, :created_at, :string
    remove_column :topic_descriptions, :updated_at, :string
  end
end
