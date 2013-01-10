class Admin::WorkshopsController < AdminController
  def index
    @workshops = Workshop.by_position.includes(:sections)
    render
  end

  def new
    @workshop = Workshop.new
    render
  end

  def create
    @workshop = Workshop.new(params[:workshop])
    if @workshop.save
      flash[:success] = 'Workshop was successfully created.'
      redirect_to admin_workshops_path
    else
      render :new
    end
  end

  def edit
    @workshop = Workshop.find(params[:id])
    render
  end

  def update
    @workshop = Workshop.find(params[:id])
    if @workshop.update_attributes(params[:workshop])
      flash[:success] = 'Workshop was successfully updated.'
      redirect_to admin_workshops_path
    else
      render 'edit'
    end
  end
end
