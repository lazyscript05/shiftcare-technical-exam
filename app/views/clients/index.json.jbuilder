json.clients @clients do |client|
  json.id client.id
  json.full_name client.full_name
  json.email client.email
end

json.pagination do
  json.page @pagy.page
  json.count @pagy.count
  json.pages @pagy.pages
  json.next @pagy.next
  json.prev @pagy.prev
end
