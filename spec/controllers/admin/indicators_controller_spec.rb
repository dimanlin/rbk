require 'rails_helper'

RSpec.describe Admin::IndicatorsController, type: :controller do

  describe '#index' do

    before do
      @indicator = FactoryGirl.create(:indicator)
      get :index
    end

    it 'success' do
      expect(response).to be_success
      expect(assigns[:indicators]).to eq([@indicator])
    end
  end

  describe '#edit' do
    before do
      @indicator = FactoryGirl.create(:indicator)
      get :edit, params: { id: @indicator.id }
    end

    it 'success response' do
      expect(response).to be_success
    end

    it 'check assigns' do
      expect(assigns[:indicator]).to eq(@indicator)
    end
  end

  describe '#update' do
    describe 'success' do
      before do
        @indicator = FactoryGirl.create(:indicator)
      end

      it 'update fix_price field' do
        expect do
          put :update, params: { id: @indicator.id, indicator: { fix_price: 222.22 } }
        end.to change { @indicator.reload.fix_price }.from(111.11).to(222.22)
      end
    end

    describe 'validation error' do
      before do
        @indicator = FactoryGirl.create(:indicator)
        put :update, params: { id: @indicator.id, indicator: { fix_price: -222 } }
      end

      it 'fix_price field' do
        expect(response).to render_template("indicators/edit")
      end
    end
  end
end
