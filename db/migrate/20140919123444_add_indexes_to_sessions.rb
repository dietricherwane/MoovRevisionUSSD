class AddIndexesToSessions < ActiveRecord::Migration
  def change
    add_index :sessions, :session_id
    add_index :sessions, :msisdn
  end
end
