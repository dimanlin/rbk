class Admin::IndicatorsController < Admin::ApplicationController

  before_action :set_indicator, only: [:edit, :update]

  def index
    @indicators = Indicator.order(subname: :desc)
  end

  def edit
  end

  def update
    if @indicator.update(indicator_params)
      redirect_to admin_indicators_path
    else
      render action: 'edit'
    end
  end

  private

  def set_indicator
    @indicator = Indicator.find(params[:id])
  end

  def indicator_params
    params.require(:indicator).permit(:fix_price, :fix_date)
  end
end
