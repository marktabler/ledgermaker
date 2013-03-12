class AddUserIdToLedger < ActiveRecord::Migration
  def change
    add_column :ledgers, :user_id, :integer
  end
end
