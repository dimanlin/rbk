require 'rails_helper'

RSpec.describe RbkRate do
  describe '#update_rate' do

    before do
      stub_request(:get, "http://www.rbc.ru/ajax/indicators?_=1499870537749").
                   to_return(status: 200, body: rbk_response, headers: {})
    end

    context 'we already have indicators' do
      let(:rbk_response) {{'currency' => [{ id: 1,
                                            name: 'name',
                                            subname: 'new_subname',
                                            chg_abs: 2,
                                            value1: 222}]}.to_json}
      before do
        @indicator = FactoryGirl.create(:indicator)
      end

      it 'changed chg_abs' do
        expect do
          RbkRate.update_rate
        end.to change {@indicator.reload.chg_abs}.from(0.12).to(2)
      end

      it 'changed value1' do
        expect do
          RbkRate.update_rate
        end.to change {@indicator.reload.value1}.from(32.9284844234).to(222)
      end
    end

    context 'we not have indicators' do
      let(:rbk_response) {{'currency' => [{ id: 1,
                                            name: 'name',
                                            subname: 'new_subname',
                                            chg_abs: 2,
                                            value1: 222}]}.to_json}

      it 'Indicator.count eq 1' do
        expect do
          RbkRate.update_rate
        end.to change { Indicator.count }.from(0).to(1)
      end
    end
  end
end
