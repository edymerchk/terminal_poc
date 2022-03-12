require 'rails_helper'

describe CsvExporter do
  subject { described_class.new(request).export  }

  let(:test_file_path) do
    Tempfile.new("csv").tap do |outfile|
      CSV.open(outfile, "ab") do |csv|
        rows.each { |row| csv << row }
      end
    end
  end

  let(:rows) do
    [
      ['bill_of_lading', 'container_number']
    ]
  end
  let!(:request) { Request.create!(bill_of_lading: '6323884470', scac: 'COSU', container_numbers: ['A', 'B']) }

  before do
    Rails.application.config.csv_file_path = test_file_path
  end

  context 'when CSV does not contains any of the Request data' do
    it "updates the CSV with the request data" do
      subject

      expect(CSV.open(test_file_path.path).readlines).to eq(
        [
          ["bill_of_lading", "container_number"],
          ["6323884470", "A"],
          ["6323884470", "B"]
        ]
      )
    end
  end

  context 'when CSV contains part of the Rquest data' do
    let(:rows) { super() << ["6323884470", "A"] }

    it "updates the CSV only with the missing data" do
      subject

      expect(CSV.open(test_file_path.path).readlines).to eq(
        [
          ["bill_of_lading", "container_number"],
          ["6323884470", "A"],
          ["6323884470", "B"]
        ]
      )
    end
  end

  context 'when CSV contains other Request  data' do
    let(:rows) { super() << ["1234", "X"] }

    it "updates the CSV with the request data" do
      subject

      expect(CSV.open(test_file_path.path).readlines).to eq(
        [
          ["bill_of_lading", "container_number"],
          ["1234", "X"],
          ["6323884470", "A"],
          ["6323884470", "B"]
        ]
      )
    end
  end
end
