require 'rails_helper'

RSpec.describe Indicator, type: :model do
  describe 'validations' do
    describe 'standart matches' do
      it 'standart matches' do
        should validate_presence_of(:value1)
        should validate_numericality_of(:value1).is_greater_than(0)
      end
    end

    describe '.check_fix_date' do
      context 'fix_price and fix_date nil' do
        let(:indicator) { FactoryGirl.create(:indicator, fix_price: nil, fix_date: nil) }

        before do
          indicator.valid?
        end

        it do
          expect(indicator.errors.messages).to eq({})
        end
      end

      context 'fix_price and fix_date present' do
        context 'fix_date > DateTime.current' do
          let(:indicator) { FactoryGirl.create(:indicator, fix_price: 111, fix_date: 1.month.from_now) }

          before do
            indicator.valid?
          end

          it do
            expect(indicator.errors.messages).to eq({})
          end
        end

        context 'fix_date < DateTime.current' do
          before do
            indicator_attributes = FactoryGirl.attributes_for(:indicator, fix_price: 111, fix_date: 1.month.ago)
            @indicator = Indicator.create(indicator_attributes)
            @indicator.valid?
          end

          it do
            expect(@indicator.errors.messages[:fix_date]).to eq(['не может быть, меньше сегодняшний даты'])
          end
        end
      end
    end
  end

  describe '.price' do
    context 'fix_date present' do
      context 'fix_price? eq true' do
        let(:indicator) { FactoryGirl.create(:indicator, fix_price: 111, fix_date: 1.month.from_now) }

        before do
          expect(indicator).to receive(:fixed_price?).and_return(true)
        end

        it 'return fix_price' do
          expect(indicator.price).to eq(indicator.fix_price)
        end
      end

      context 'fix_price? eq false' do
        let(:indicator) { FactoryGirl.create(:indicator, fix_price: nil, fix_date: nil) }

        before do
          expect(indicator).to receive(:fixed_price?).and_return(false)
        end

        it 'return fix_price' do
          expect(indicator.price).to eq(indicator.value1)
        end
      end
    end
  end

  describe '.fixed_price?' do
    context 'if fix_date present' do
      let(:indicator) { FactoryGirl.create(:indicator, fix_price: 111, fix_date: DateTime.parse('2017-01-01')) }

      before do
        Timecop.freeze(Time.local(1990))
      end

      it 'return true' do
        expect(indicator.fixed_price?).to be_truthy
      end
    end

    context 'if fix_date present' do
      let(:indicator) { FactoryGirl.create(:indicator, fix_price: nil, fix_date: nil) }
      it 'return false' do
        expect(indicator.fixed_price?).to be_falsy
      end
    end
  end

  describe '.broadcast_attributes' do
    let(:indicator) { FactoryGirl.create(:indicator) }

    it 'return hash' do
      expect(indicator.broadcast_attributes).to eq({  remote_id: 1,
                                                      name: "name",
                                                      subname: "subname",
                                                      price: 111.11,
                                                      chg_abs: 0.12 })
    end
  end

  describe '.auto_update' do
    context 'if fix_date present and fix_date less current time' do
      before do
        Timecop.freeze(DateTime.parse('2017-01-01'))
        @indicator = FactoryGirl.create(:indicator, fix_date: DateTime.parse('2017-01-07'), fix_price: 111)
        Timecop.freeze(DateTime.parse('2017-01-10'))
      end

      it 'change fix_date to nil' do
        expect do
          @indicator.auto_update({})
        end.to change { @indicator.fix_date }.from(DateTime.parse('2017-01-07')).to(nil)
      end

      it 'change fix_date to nil' do
        expect do
          @indicator.auto_update({})
        end.to change { @indicator.fix_price }.from(111).to(nil)
      end

    end
  end
end
