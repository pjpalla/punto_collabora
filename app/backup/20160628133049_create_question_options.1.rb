class CreateQuestionOptions < ActiveRecord::Migration
  def change
    create_table :question_options do |t|

      t.timestamps null: false
    end
  end
end
