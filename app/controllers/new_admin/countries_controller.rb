class NewAdmin::CountriesController < AdminController
  load_and_authorize_resource find_by: :namespace

  def index
    @countries = Country.all.order_by name: :asc
    @country ||= Country.new
  end

  def create
    if @country.save
      flash[:notice] = "#{@country} has correctly been created"
      respond_with :new_admin, @country, location: new_admin_countries_path
    else
      load_countries
      render :index
    end
  end

  def destroy
    @country.destroy
    flash[:notice] = "#{@country} has been destroyed !"
    respond_with :new_admin, @country
  end

  def edit
  end

  def update
    @country.update_attributes(params[:country])
    flash[:notice] = "#{@country} has been updated"
    respond_with :new_admin, @country, location: new_admin_countries_path
  end
end
