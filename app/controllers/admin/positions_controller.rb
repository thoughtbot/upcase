class Admin::PositionsController < AdminController
  def update
    @course = Course.find(params[:course_id])
    @course.insert_at(params[:position].to_i)
    render :nothing => true
  end
end
