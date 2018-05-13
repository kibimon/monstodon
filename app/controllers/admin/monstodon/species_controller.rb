class Admin::Monstodon::SpeciesController < Admin::BaseController
  def index
    authorize Monstodon::Species, :index?
    @species = Monstodon::Species.all
  end

  def new
    authorize Monstodon::Species, :create?

    @species = Monstodon::Species.new
  end

  def create
    authorize Monstodon::Species, :create?

    @species = Monstodon::Species.new(resource_params)

    if @species.save
      redirect_to admin_monstodon_species_index_path, notice: I18n.t('monstodon.admin.species.created_msg')
    end
  end

  private

  def resource_params
    params.require(:monstodon_species).permit(
      :name,
      :regional_no,
      :national_no
    )
  end
end
