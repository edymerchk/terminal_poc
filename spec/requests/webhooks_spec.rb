require 'rails_helper'

RSpec.describe "Webhooks endpoint", type: :request do
  subject do
    post "/webhooks", params: payload, headers: header_with_terminal_signature(payload)
  end

  before do
    Terminal49.configure do |config|
      config.webhook_secret = "SAMPLE_SECRET"
    end
  end

  let(:payload) { JSON.parse(File.read(File.join('spec', 'fixtures', 'tracking_request.succeded.json'))) }
  let!(:request) { Request.create!(tracking_request_id: '20a00a91-8ce9-444f-a0a2-44252abd5c68', bill_of_lading: '6323884470', scac: 'COSU') }

  it "returns a response with an HTTP status of 200" do
    subject

    expect(response).to have_http_status(200)
  end

  it "updates the request with the container numbers" do
    subject

    expect(request.reload.container_numbers).to eq(["TRHU7400728", "SEGU6620693", "RFCU4066146", "FCIU9511172", "FCIU9148576", "CSNU6250223"])
  end

  context 'with an invalid signature' do
    subject do
      post "/webhooks", params: payload, headers: { "X-T49-Webhook-Signature" => "INVALID" }
    end

    it 'returns a response with an HTTP status of 400' do
      subject

      expect(response).to have_http_status(400)
    end
  end
end
