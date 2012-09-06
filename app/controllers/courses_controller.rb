class CoursesController < ApplicationController
  def index
    @audiences = Audience.by_position
    @books = Product.active.where("product_type LIKE '%book%'")
    @screencasts = Product.active.where("product_type LIKE '%screencast%'")
  end

  def show
    @course = Course.find(params[:id])
    @sections = @course.sections.active
  end
end
