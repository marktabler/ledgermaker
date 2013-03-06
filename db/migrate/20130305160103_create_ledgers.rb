class CreateLedgers < ActiveRecord::Migration
  def change
    create_table :ledgers do |t|
      t.string :title

      t.timestamps
    end
  end
end
