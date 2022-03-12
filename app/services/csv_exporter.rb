require 'csv'

class CsvExporter
  attr_accessor :request, :bill_of_lading, :path

  def initialize(request)
    @request = request
    @bill_of_lading = request.bill_of_lading
    @path = Rails.application.config.csv_file_path
  end

  def export
    CSV.open(path, "ab") do |csv|
      request.container_numbers.each do |container_number|
        csv << [bill_of_lading, container_number] unless find_row(container_number)
      end
    end
  end

  private

  def find_row(container_number)
    CSV.read(path, headers: true ).find do |row|
      row['bill_of_lading'] == bill_of_lading && row['container_number'] == container_number
    end
  end
end
