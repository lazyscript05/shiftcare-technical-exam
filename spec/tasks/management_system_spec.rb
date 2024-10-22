require "rake"
require "terminal-table"

RSpec.describe "ManagementSystem Rake Task" do
  let(:rake) { Rake::Application.new }
  let(:task_name) { "management_system:cli" }
  let(:task) { rake[task_name] }

  before do
    Rake.application = rake
    Rake.application.rake_require("tasks/management_system", [Rails.root.join("lib")])
    Rake::Task.define_task(:environment)
  end

  def load_data
    Client.all.map(&:attributes)
  end

  def search_data(data, field, query)
    data.select { |item| item[field].to_s.downcase.include?(query.downcase) }
  end

  def find_duplicates(data, field)
    values = data.pluck(field)
    duplicates = values.select { |v| values.count(v) > 1 }.uniq
    data.select { |item| duplicates.include?(item[field]) }
  end

  def display_table(data)
    if data.empty?
      puts "No data to display."
      return
    end

    headings = data.first.keys.reject { |key| %w[id created_at updated_at].include?(key) }
      .map { |key| key.split("_").map(&:capitalize).join(" ") }

    table = Terminal::Table.new(headings: headings) do |t|
      t.rows = data.map do |item|
        headings.map { |heading| item[heading.downcase.tr(" ", "_")] }
      end
    end
    puts table
  end

  def prompt_choice(options)
    options.each_with_index { |opt, idx| puts "#{idx + 1}. #{opt}" }
    print "\nYour choice (number): "
    options[$stdin.gets.chomp.to_i - 1]
  end

  def main
    data = load_data
    if data.empty?
      puts "❌ - No data available."
      return
    end

    fields = data.first.keys.reject { |key| %w[id created_at updated_at].include?(key) }
      .map { |key| key.split("_").map(&:capitalize).join(" ") }

    loop do
      puts "\nWelcome to the ShiftCare Client Manager System!"
      puts "========================================"
      puts "Choose an option:"
      choice = prompt_choice(["Search data by a field", "Find data with duplicate values", "Exit"])

      case choice
      when "Search data by a field"
        field = prompt_choice(fields)
        print "\nEnter your search query: "
        query = $stdin.gets.chomp
        results = search_data(data, field.downcase.tr(" ", "_"), query)
        puts "\nSearch Results:"
        display_table(results)
      when "Find data with duplicate values"
        field = prompt_choice(fields)
        duplicates = find_duplicates(data, field.downcase.tr(" ", "_"))
        puts "\nDuplicate #{field}:"
        display_table(duplicates)
      when "Exit"
        puts "\n✅ - Thank you for using the ShiftCare Client Manager System. Goodbye!"
        break
      else
        puts "\n❌ - Invalid option. Please select a valid number."
      end
    end
  end

  describe "load_data" do
    it "loads all client data" do
      create_list(:client, 5)
      expect(load_data.size).to eq(5)
    end
  end

  describe "search_data" do
    let(:data) { [{"full_name" => "John Doe"}, {"full_name" => "Jane Smith"}] }

    it "returns matching entries" do
      results = search_data(data, "full_name", "john")
      expect(results).to eq([{"full_name" => "John Doe"}])
    end

    it "is case insensitive" do
      results = search_data(data, "full_name", "JOHN")
      expect(results).to eq([{"full_name" => "John Doe"}])
    end

    it "returns empty array if no matches" do
      results = search_data(data, "full_name", "nonexistent")
      expect(results).to be_empty
    end
  end

  describe "find_duplicates" do
    let(:data) { [{"email" => "test@example.com"}, {"email" => "test@example.com"}, {"email" => "unique@example.com"}] }

    it "returns entries with duplicate values" do
      results = find_duplicates(data, "email")
      expect(results).to eq([{"email" => "test@example.com"}, {"email" => "test@example.com"}])
    end

    it "returns empty array if no duplicates" do
      results = find_duplicates([{"email" => "unique@example.com"}], "email")
      expect(results).to be_empty
    end
  end

  describe "display_table" do
    it "displays a table with data" do
      data = [{"full_name" => "John Doe", "email" => "john@example.com"}]
      expect { display_table(data) }.to output(/John Doe/).to_stdout
    end

    it "displays a message if no data" do
      expect { display_table([]) }.to output(/No data to display/).to_stdout
    end
  end

  describe "prompt_choice" do
    it "returns the selected option" do
      allow($stdin).to receive(:gets).and_return("1")
      options = ["Option 1", "Option 2"]
      expect(prompt_choice(options)).to eq("Option 1")
    end
  end

  describe "main" do
    it "exits the loop when 'Exit' is chosen" do
      create_list(:client, 5) # Ensure there is data
      allow($stdin).to receive(:gets).and_return("3")
      expect { main }.to output(/Goodbye!/).to_stdout
    end
  end
end
