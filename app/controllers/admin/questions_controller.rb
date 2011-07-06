class Admin::QuestionsController < AdminController
  def destroy
    course = Course.find(params[:course_id])
    question = course.questions.find(params[:id])
    question.destroy
    flash[:notice] = "Question removed"
    redirect_to edit_admin_course_path(course)
  end
end
