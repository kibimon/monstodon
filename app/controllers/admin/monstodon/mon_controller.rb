class Admin::Monstodon::MonController < Admin::BaseController
  def index
    redirect_to controller: '/admin/accounts', type: 'mon'
  end

  def new
    authorize Monstodon::Mon, :create?
    @mon = Monstodon::Mon.new
  end

  def create
    authorize Monstodon::Mon, :create?
    required = params.require(:monstodon_mon)
    @mon = Monstodon::Mon.new(create_params(required))
    if required.key?(:owner_trainer_no)
      @mon.owner = Account.trainer(required.fetch(:owner_trainer_no))
    end
    if required.key?(:national_no)
      @mon.species = Monstodon::Species.where(find_species_params(required)).first
    end
    if @mon.save
      redirect_to action: 'new', notice: I18n.t('monstodon.admin.mon.created_msg')
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
