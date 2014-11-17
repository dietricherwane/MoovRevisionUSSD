class AddTrashToInputLogs < ActiveRecord::Migration
  def change
    add_column :input_logs, :trash, :text
  end
end
