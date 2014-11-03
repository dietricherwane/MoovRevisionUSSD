class AddUssdIdToQuestionTypes < ActiveRecord::Migration
  def change
    add_column :question_types, :ussd_id, :integer
  end
end
