# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Health endpoint", type: :request do
  describe "GET /health" do
    it "returns a successful health status with a timestamp" do
      get "/health"

      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq("application/json; charset=utf-8")

      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("ok")
      expect(json_response["timestamp"]).to be_present
    end

    it "returns a valid timestamp" do
      get "/health"

      json_response = JSON.parse(response.body)
      timestamp = json_response["timestamp"]

      # Validation checks for 8601 format
      expect(timestamp).to be_present
      expect(Time.parse(timestamp)).to be_a(Time)
    end

    it "returns only the expected keys" do
      get "/health"

      json_response = JSON.parse(response.body)
      expected_keys = [ "status", "timestamp" ]

      expect(json_response.keys).to match_array(expected_keys)
    end

    it "returns a recent timestamp" do
      get "/health"

      json_response = JSON.parse(response.body)

      timestamp = Time.parse(json_response["timestamp"])
      expect(timestamp).to be > 5.seconds.ago
      expect(timestamp).to be <= Time.current
    end
  end
end
