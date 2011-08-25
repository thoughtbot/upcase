class Admin::AudiencesController < AdminController
  def index
    @audiences = Audience.all
  end

  def new
    @audience = Audience.new
  end

  def create
    @audience = Audience.new(params[:audience])
    if @audience.save
      flash[:success] = "Audience successfully created"
      redirect_to admin_audiences_path
    else
      render :new
    end
  end

  def edit
    @audience = Audience.find(params[:id])
  end

  def update
    @audience = Audience.find(params[:id])
    if @audience.update_attributes(params[:audience])
      flash[:success] = "Audience successfully updated"
      redirect_to admin_audiences_path
    else
      render :edit
    end
  end
end
