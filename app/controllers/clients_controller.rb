class ClientsController < ApplicationController
  include Pagy::Backend

  ALLOWED_FIELDS = Client.column_names - %w[id created_at updated_at]

  def index
    queries = Client.all

    if params[:q].present?
      field = params[:field] || "full_name"
      return render_error("Invalid search field: #{field}") unless ALLOWED_FIELDS.include?(field)
      return render_error("Search query can't be blank") if params[:q].blank?

      queries = ClientSearchService.new(query: params[:q], field: field).search
    elsif params[:duplicates].present?
      field = params[:field]
      return render_error("Field parameter is required") if field.blank?
      return render_error("Invalid field: #{field}") unless ALLOWED_FIELDS.include?(field)

      queries = ClientDuplicateService.new(field: field).find_duplicates
    end

    @pagy, @clients = pagy(queries)
    respond_to do |format|
      format.html
      format.json
    end
  end

  private

  def render_error(message)
    render json: {error: message}, status: :bad_request
  end
end
