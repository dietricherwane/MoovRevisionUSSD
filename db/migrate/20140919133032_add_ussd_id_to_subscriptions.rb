class AddUssdIdToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :ussd_id, :integer
  end
end
