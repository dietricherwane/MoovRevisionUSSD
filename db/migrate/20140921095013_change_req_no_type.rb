class ChangeReqNoType < ActiveRecord::Migration
  def change
    remove_column :sessions, :req_no
    add_column :sessions, :req_no, :integer
  end
end
