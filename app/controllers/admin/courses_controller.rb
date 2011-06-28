class Admin::CoursesController < AdminController
  def index
    @courses = Course.by_position
    render
  end

  def new
    @course = Course.new
    render
  end

  def create
    @course = Course.new(params[:course])
    if @course.save
      flash[:success] = 'Course was successfully created.'
      redirect_to admin_courses_path
    else
      render :new
    end
  end

  def edit
    @course = Course.find(params[:id])
    render
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(params[:course])
      respond_to do |format|
        format.html do
          flash[:success] = 'Course was successfully updated.'
          redirect_to admin_courses_path
        end
        format.js { render :nothing => true }
      end
    else
      render 'edit'
    end
  end
end
