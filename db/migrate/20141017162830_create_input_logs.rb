class CreateInputLogs < ActiveRecord::Migration
  def change
    create_table :input_logs do |t|
      t.string :content

      t.timestamps
    end
  end
end
