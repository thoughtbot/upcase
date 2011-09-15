class Admin::TeachersController < AdminController
  def index
    @teachers = Teacher.by_name
  end

  def new
    @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(params[:teacher])
    if @teacher.save
      redirect_to admin_teachers_path
    else
      render :new
    end
  end
end
