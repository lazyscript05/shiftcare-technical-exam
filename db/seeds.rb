require "json"

# Read the JSON file and parse it
file_path = Rails.root.join("db/seeds/client.json")
client_data = JSON.parse(File.read(file_path), symbolize_names: true)

client_data.each do |client|
  # Create a new Client record for each entry
  Client.create(
    email: client[:email],
    full_name: client[:full_name]
  )
end
