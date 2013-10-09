class Api::V1::CompletionsController < ApiController
  doorkeeper_for :all, if: lambda { !signed_in? }

  def index
    respond_with current_resource_owner.completions.only_trail_object_ids
  end

  def create
    completion = current_resource_owner.completions.create(
      trail_object_id: params[:trail_object_id],
      trail_name: params[:trail_name]
    )
    respond_with :api, :v1, completion
  end

  def show
    completion = lookup_completion(params[:id])
    respond_with completion
  end

  def destroy
    completion = lookup_completion(params[:id])
    completion.destroy
    respond_with :api, :v1, completion
  end

  private

  def lookup_completion(trail_object_id)
    current_resource_owner.completions.find_by_trail_object_id!(trail_object_id)
  end

  def current_resource_owner
    current_user || resource_owner
  end
end
