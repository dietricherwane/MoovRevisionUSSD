class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :msisdn, limit: 100
      t.integer :subscription_id
      t.integer :question_type_id
      t.integer :academic_level_id
      t.string :sc, limit: 100
      t.string :session_id, limit: 100
      t.string :req_no, limit: 100

      t.timestamps
    end
  end
end
