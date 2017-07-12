class CreateIndicators < ActiveRecord::Migration[5.1]
  def change
    create_table :indicators do |t|
      t.integer :remote_id
      t.string :name
      t.string :subname
      t.decimal :chg_abs, precision: 8, scale: 2
      t.decimal :value1
      t.timestamps
    end
  end
end
