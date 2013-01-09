class Admin::PositionsController < AdminController
  def update
    @workshop = Workshop.find(params[:workshop_id])
    @workshop.insert_at(params[:position].to_i)
    render nothing: true
  end
end
