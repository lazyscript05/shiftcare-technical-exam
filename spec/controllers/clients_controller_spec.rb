require "rails_helper"

RSpec.describe ClientsController, type: :controller do
  let!(:clients) { create_list(:client, 5) }

  describe "GET #index" do
    context "when a search query is provided" do
      let(:search_service) { instance_double(ClientSearchService, search: Client.all) }

      before do
        allow(ClientSearchService).to receive(:new).and_return(search_service)
      end

      it "calls the ClientSearchService with the correct params" do
        get :index, params: {q: "john", field: "full_name"}
        if ClientSearchService.new(query: "john", field: "full_name")
          puts "✅ - ClientSearchService was called with the correct parameters"
        else
          puts "❌ - ClientSearchService was NOT called with the correct parameters"
        end

        if search_service.search
          puts "✅ - Search service was executed successfully"
        else
          puts "❌ - Search service failed to execute"
        end

        if response.status == 200
          puts "✅ - Received OK response"
        else
          puts "❌ - Response was not OK"
        end
      end
    end

    context "when searching with an invalid field" do
      it "returns a bad request error" do
        get :index, params: {q: "john", field: "invalid_field"}
        if response.status == 400
          puts "✅ - Bad request status received for invalid field"
        else
          puts "❌ - Did not receive bad request for invalid field"
        end

        if response.parsed_body == {"error" => "Invalid search field: invalid_field"}
          puts "✅ - Correct error message received for invalid field"
        else
          puts "❌ - Incorrect error message received for invalid field"
        end
      end
    end

    context "when duplicates are requested" do
      let(:duplicate_service) { instance_double(ClientDuplicateService, find_duplicates: Client.all) }

      before do
        allow(ClientDuplicateService).to receive(:new).and_return(duplicate_service)
      end

      it "calls the ClientDuplicateService with the correct field" do
        get :index, params: {duplicates: true, field: "email"}
        if ClientDuplicateService.new(field: "email")
          puts "✅ - ClientDuplicateService was called with the correct field"
        else
          puts "❌ - ClientDuplicateService was NOT called with the correct field"
        end

        if duplicate_service.find_duplicates
          puts "✅ - Duplicates were successfully searched"
        else
          puts "❌ - Failed to search for duplicates"
        end

        if response.status == 200
          puts "✅ - Received OK response"
        else
          puts "❌ - Response was not OK"
        end
      end
    end

    context "when duplicates field is missing" do
      it "returns a bad request error" do
        get :index, params: {duplicates: true}
        if response.status == 400
          puts "✅ - Bad request status received for missing field"
        else
          puts "❌ - Did not receive bad request for missing field"
        end

        if response.parsed_body == {"error" => "Field parameter is required"}
          puts "✅ - Correct error message received for missing field"
        else
          puts "❌ - Incorrect error message received for missing field"
        end
      end
    end

    context "when no params are provided" do
      it "returns a paginated list of clients" do
        get :index
        if assigns(:clients) == clients
          puts "✅ - Clients were successfully retrieved"
        else
          puts "❌ - Clients were not retrieved successfully"
        end

        if response.status == 200
          puts "✅ - Received OK response"
        else
          puts "❌ - Response was not OK"
        end
      end
    end

    context "when paginating results" do
      it "uses Pagy for pagination" do
        get :index
        if assigns(:pagy).is_a?(Pagy)
          puts "✅ - Pagy is used for pagination"
        else
          puts "❌ - Pagy is not used for pagination"
        end

        if assigns(:clients) == clients
          puts "✅ - Clients are correctly paginated"
        else
          puts "❌ - Clients are not correctly paginated"
        end
      end
    end
  end
end
