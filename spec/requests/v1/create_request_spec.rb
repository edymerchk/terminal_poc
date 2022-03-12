require "rails_helper"

RSpec.describe "Create Request API", type: :request do
  subject do
    post "/v1/requests", params: payload.to_json, headers: jsonapi_headers
  end

  let(:payload) do
    {
      data: {
        type: "requests",
        attributes: {
          bill_of_lading: "W226267303",
          scac: "YMLU"
        }
      }
    }
  end

  it "returns a response with an HTTP status of 201" do
    VCR.use_cassette("terminal49/tracking_requests/create") do
      subject

      expect(response).to have_http_status(201)
    end
  end

  it "creates a Request record" do
    VCR.use_cassette("terminal49/tracking_requests/create") do
      expect { subject }.to change { Request.count }.by(1)
    end
  end

  it "returns a JSONAPI response with the object created" do
    VCR.use_cassette("terminal49/tracking_requests/create") do
      subject

      expect(json_response[:data][:attributes]).to eq(
        "bill_of_lading" => "W226267303",
        "scac" => "YMLU"
      )
    end
  end

  context 'when the request already exists' do
    before do
      Request.create!(bill_of_lading: "W226267303", scac: "YMLU")
    end

    let(:payload) do
      {
        data: {
          type: "requests",
          attributes: {
            bill_of_lading: "W226267303",
            scac: "YMLU"
          }
        }
      }
    end

    it 'returns a response with an HTTP status of 422' do
      subject

      expect(response).to have_http_status(422)
    end

    it 'does not create a Request record' do
      expect { subject }.not_to change { Request.count }
    end

    it "returns an appropriate JSON API error" do
      subject

      expect(json_response[:errors].first[:detail]).to eq "Validation failed: Bill of lading and scac request already exists"
    end
  end

  context 'when parameters are missing' do
    let(:payload) do
      {
        data: {
          type: "requests",
          attributes: {
            bill_of_lading: "W226267303",
          }
        }
      }
    end

    it "returns a response with an HTTP status of 422" do
      subject

      expect(response).to have_http_status(422)
    end

    it "returns an appropriate JSON API error" do
      subject

      expect(json_response[:errors].first[:detail]).to eq "Validation failed: Scac can't be blank"
    end
  end
end
