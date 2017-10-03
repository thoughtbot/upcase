class Api::V1::VideosController < ApiController
  def index
    show = find_show
    render json: { videos: show.videos }
  end

  private

  def find_show
    Show.friendly.find(params[:show_id])
  end
end
