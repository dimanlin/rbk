require 'rails_helper'

RSpec.describe RatesController, type: :controller do

  describe '#show' do

    before do
      FactoryGirl.create(:indicator)
      get :show
    end

    it 'success' do
      expect(response).to be_success
      expect(assigns[:indicators]).to eq([{ remote_id: 1,
                                            name: 'name',
                                            subname: 'subname',
                                            price: 111.11,
                                            chg_abs: 0.12 }])
    end
  end
end
