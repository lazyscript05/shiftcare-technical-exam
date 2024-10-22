require "terminal-table"

namespace :management_system do
  desc "Run the ShiftCare Client Manager System CLI"
  task cli: :environment do
    # Loads all client data and returns it as an array of hashes.
    def load_data
      Client.all.map(&:attributes)
    end

    # Searches the given data for entries where the specified field contains the query.
    #
    # @param data [Array<Hash>] The data to search through.
    # @param field [String] The field to search in.
    # @param query [String] The search query.
    # @return [Array<Hash>] The filtered data containing the search query.
    def search_data(data, field, query)
      data.select { |item| item[field].to_s.downcase.include?(query.downcase) }
    end

    # Finds and returns entries in the data that have duplicate values in the specified field.
    #
    # @param data [Array<Hash>] The data to check for duplicates.
    # @param field [String] The field to check for duplicates.
    # @return [Array<Hash>] The data containing duplicate values.
    def find_duplicates(data, field)
      values = data.pluck(field)
      duplicates = values.select { |v| values.count(v) > 1 }.uniq
      data.select { |item| duplicates.include?(item[field]) }
    end

    # Displays data in a tabular format using the Terminal::Table gem.
    #
    # @param data [Array<Hash>] The data to display in the table.
    def display_table(data)
      if data.empty?
        puts "No data to display."
        return
      end

      # Generate table headings by transforming keys from snake_case to Title Case
      headings = data.first.keys.reject { |key| %w[id created_at updated_at].include?(key) }
        .map { |key| key.split("_").map(&:capitalize).join(" ") }

      # Create and display the table
      table = Terminal::Table.new(headings: headings) do |t|
        t.rows = data.map do |item|
          headings.map { |heading| item[heading.downcase.tr(" ", "_")] }
        end
      end
      puts table
    end

    # Prompts the user to choose an option from a list and returns the selected option.
    #
    # @param options [Array<String>] The list of options to choose from.
    # @return [String] The selected option.
    def prompt_choice(options)
      options.each_with_index { |opt, idx| puts "#{idx + 1}. #{opt}" }
      print "\nYour choice (number): "
      options[$stdin.gets.chomp.to_i - 1]
    end

    # Main method that drives the CLI interaction.
    # It provides a looped menu system for the user to interact with.
    def main
      data = load_data
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
          puts "\nThank you for using the ShiftCare Client Manager System. Goodbye!"
          break
        else
          puts "\nInvalid option. Please select a valid number."
        end
      end
    end

    # Execute the main method to start the CLI
    main
  end
end
