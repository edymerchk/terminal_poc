class UpdateRequest
  attr_accessor :tracking_request_id, :containers

  def initialize(tracking_request_id, containers)
    @tracking_request_id = tracking_request_id
    @containers = containers
  end

  def call
    unless request
      Rails.logger.error "Could not find request with tracking_request_id: #{tracking_request_id}"
      return
    end

    request.update!(container_numbers: container_numbers)

    CsvExporter.new(request).export
  end

  private

  def request
    @request ||= Request.find_by(tracking_request_id: tracking_request_id)
  end

  def container_numbers
    containers.map {|c| c['attributes']['number']}
  end
end
