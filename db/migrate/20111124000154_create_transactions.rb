class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.integer :user_id
      t.float :amount
      t.date :date
      t.string :location
      t.string :description
      t.string :tag

      t.timestamps
    end
    add_index :transactions, [:user_id, :date]
  end

  def self.down
    drop_table :transactions
  end
end
