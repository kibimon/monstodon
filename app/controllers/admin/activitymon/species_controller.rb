class Admin::ActivityMon::SpeciesController < Admin::BaseController
  def index
    authorize ActivityMon::Species, :index?
    @species = ActivityMon::Species.all
  end

  def new
    authorize ActivityMon::Species, :create?

    @species = ActivityMon::Species.new
  end

  def create
    authorize ActivityMon::Species, :create?

    @species = ActivityMon::Species.new(resource_params)

    if @species.save
      redirect_to admin_activitymon_species_index_path, notice: I18n.t('activitymon.admin.species.created_msg')
    end
  end

  private

  def resource_params
    params.require(:activitymon_species).permit(:name, :uri)
  end
end
