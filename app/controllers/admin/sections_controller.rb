class Admin::SectionsController < AdminController
  def new
    @course   = Course.find(params[:course_id])
    @section  = @course.sections.build(start_at: @course.start_at,
                                       stop_at: @course.stop_at)
    @teachers = Teacher.all
    @section.section_teachers.build
  end

  def create
    @course  = Course.find(params[:course_id])
    @section = @course.sections.build(params[:section])
    if @section.save
      flash[:success] = 'Section was successfully created'
      redirect_to admin_courses_path
    else
      @teachers = Teacher.all
      @section.section_teachers.build
      render :new
    end
  end

  def edit
    @section  = Section.find(params[:id])
    @course   = @section.course
    @teachers = Teacher.all
  end

  def update
    @course   = Course.find(params[:course_id])
    @section  = @course.sections.find(params[:id])
    @teachers = Teacher.all
    if @section.update_attributes(params[:section])
      flash[:success] = 'Section was successfully updated'
      redirect_to admin_courses_path
    else
      render 'edit'
    end
  end

  def destroy
    section = Section.find(params[:id])
    section.destroy
    redirect_to admin_courses_path, notice: "Section deleted"
  end
end
