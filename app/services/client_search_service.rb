class ClientSearchService
  ALLOWED_FIELDS = %w[full_name email].freeze # Specify allowed fields

  def initialize(query:, field:)
    @query = query
    @field = field if ALLOWED_FIELDS.include?(field)
  end

  def search
    # Assuming @field has been validated
    Client.where("#{@field} ILIKE ?", "%#{@query}%")
  end
end
