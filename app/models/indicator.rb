class Indicator < ApplicationRecord

  validates :value1, presence: true
  validates :value1, numericality: { greater_than: 0 }
  validates :fix_price, numericality: { greater_than: 0 }, if: Proc.new { |indicator| indicator.fix_date.present? }

  validate :check_fix_date

  after_update :send_broadcast

  def price
    fixed_price? ? fix_price : self.value1
  end

  def fixed_price?
    fix_date.present? ? DateTime.current.utc <= fix_date.utc : false
  end

  def broadcast_attributes
    { remote_id: remote_id,
      name: name,
      subname: subname,
      price: price,
      chg_abs: chg_abs }
  end

  def auto_update(attr)
    if fix_date.present? && DateTime.now.utc > fix_date.utc
      attr.merge!( { fix_price: nil, fix_date: nil } )
    end

    update(attr)
  end

  private

  def check_fix_date
    if fix_price.present? && fix_date.present?
      if fix_date.utc <= DateTime.current.utc
        self.errors.add(:fix_date, 'не может быть, меньше сегодняшний даты')
      end
    end
  end

  def send_broadcast
    ActionCable.server.broadcast "rates", { data: broadcast_attributes } if saved_changes?
  end

end
