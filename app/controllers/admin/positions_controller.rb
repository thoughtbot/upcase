class Admin::PositionsController < AdminController
  def update
    @course = Course.find(params[:course_id])
    @course.insert_at(params[:position])
    render nothing: true
  end
end
