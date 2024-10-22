class ClientDuplicateService
  ALLOWED_FIELDS = %w[full_name email].freeze # Specify allowed fields

  def initialize(field:)
    @field = field if ALLOWED_FIELDS.include?(field)
  end

  def find_duplicates
    # Assuming @field has been validated
    duplicates = Client.group(@field).having("count(#{@field}) > 1").pluck(@field)
    Client.where(@field => duplicates)
  end
end
