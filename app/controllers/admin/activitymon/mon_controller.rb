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
    required = params.require(:activitymon_mon)
    @mon = ActivityMon::Mon.new(create_params(required))
    if required.key?(:owner_trainer_no)
      @mon.owner = Account.trainer(required.fetch(:owner_trainer_no))
    end
    if required.key?(:national_no)
      @mon.species = ActivityMon::Species.where(find_species_params(required)).first
    end
    if @mon.save
      redirect_to action: 'new'
    else
      render :new
    end
  end

  private

  def create_params(required)
    required.permit(:display_name)
  end

  def find_species_params(required)
    required.permit(:national_no)
  end
end
