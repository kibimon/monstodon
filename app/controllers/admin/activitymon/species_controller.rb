class Admin::ActivityMon::SpeciesController < Admin::BaseController
  def index
    authorize ActivityMon::Species, :index?
    @species = ActivityMon::Species.all
  end
end
