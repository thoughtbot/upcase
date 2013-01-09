class Admin::QuestionsController < AdminController
  def destroy
    workshop = Workshop.find(params[:workshop_id])
    question = workshop.questions.find(params[:id])
    question.destroy
    flash[:notice] = "Question removed"
    redirect_to edit_admin_workshop_path(workshop)
  end
end
