class AddColumnFixPriceAndFixDate < ActiveRecord::Migration[5.1]
  def change
    add_column :indicators, :fix_price, :decimal, precision: 8, scale: 2
    add_column :indicators, :fix_date, :datetime
  end
end
