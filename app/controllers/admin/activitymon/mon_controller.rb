class Admin::ActivityMon::MonController < Admin::BaseController
  def index
    redirect_to controller: '/admin/accounts', type: 'mon'
  end

  def new
    authorize ActivityMon::Mon, :create?
    @mon = ActivityMon::Mon.new
  end

  def create
    authorize ActivityMon::Mon, :create?
    @mon = ActivityMon::Mon.new(create_params)
    if params[:trainer_id]
      @mon.owner = Account.trainer(find_trainer_params)
    end
    if params[:national_dex]
      @mon.species = ActivityMon::Species.where(find_species_params).first
    end
    if @mon.save
      redirect_to account_path(username: "mon_#{@mon.mon_id}")
    else
      render :new
    end
  end

  private

  def create_params
    params.permit(:display_name)
  end

  def find_species_params
    params.permit(:national_dex)
  end

  def find_trainer_params
    params.permit(:trainer_id)
  end
end
