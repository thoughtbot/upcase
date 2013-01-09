class Admin::SectionsController < AdminController
  def new
    @workshop = Workshop.find(params[:workshop_id])
    @section = @workshop.sections.build(start_at: @workshop.start_at,
      stop_at: @workshop.stop_at)
    @teachers = Teacher.all
    @section.section_teachers.build
  end

  def create
    @workshop = Workshop.find(params[:workshop_id])
    @section = @workshop.sections.build(params[:section])
    if @section.save
      flash[:success] = 'Section was successfully created'
      redirect_to admin_workshops_path
    else
      @teachers = Teacher.all
      @section.section_teachers.build
      render :new
    end
  end

  def edit
    @section = Section.find(params[:id])
    @workshop = @section.workshop
    @teachers = Teacher.all
  end

  def update
    @workshop = Workshop.find(params[:workshop_id])
    @section = @workshop.sections.find(params[:id])
    @teachers = Teacher.all
    if @section.update_attributes(params[:section])
      flash[:success] = 'Section was successfully updated'
      redirect_to admin_workshops_path
    else
      render 'edit'
    end
  end

  def destroy
    section = Section.find(params[:id])
    section.destroy
    redirect_to admin_workshops_path, notice: "Section deleted"
  end
end
