class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.datetime :date
      t.integer :value_in_cents
      t.string :title
      t.integer :ledger_id

      t.timestamps
    end
  end
end
