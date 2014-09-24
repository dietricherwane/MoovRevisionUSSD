class AddUserInputToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :user_input, :integer
  end
end
