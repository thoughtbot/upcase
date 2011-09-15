class Admin::TeachersController < AdminController
  def index
    @teachers = Teacher.by_name
  end

  def new
    @teacher = Teacher.new
    session[:after_create_teacher_path] = params[:to]
  end

  def create
    @teacher = Teacher.new(params[:teacher])
    if @teacher.save
      redirect_to session[:after_create_teacher_path].presence || admin_teachers_path
      session[:after_create_teacher_path] = nil
    else
      render :new
    end
  end

  def edit
    @teacher = Teacher.find(params[:id])
  end

  def update
    @teacher = Teacher.find(params[:id])
    if @teacher.update_attributes(params[:teacher])
      redirect_to admin_teachers_path
    else
      render :edit
    end
  end
end
