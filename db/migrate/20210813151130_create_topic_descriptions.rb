class CreateTopicDescriptions < ActiveRecord::Migration
  def change
    create_table :topic_descriptions do |t|
      t.integer :aid
      t.string :typology
      t.string :topic
      t.text :description

      t.timestamps null: false
    end
  end
end
