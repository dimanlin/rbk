FactoryGirl.define do
  factory :indicator do
    remote_id 1
    name 'name'
    subname 'subname'
    chg_abs '0.12'
    value1 32.9284844234
    fix_price 111.11
    fix_date 3.month.from_now
  end
end
