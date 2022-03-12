class RequestCreator
  attr_accessor :bill_of_lading, :scac

  REQUEST_TYPE = "bill_of_lading".freeze

  def initialize(params)
    @bill_of_lading = params[:bill_of_lading]
    @scac = params[:scac]
  end

  def create!
    request = Request.new(bill_of_lading: bill_of_lading, scac: scac)

    raise ActiveRecord::RecordInvalid, request unless request.valid?

    request.tap do |request|
      request.update!(tracking_request_id: tracking_request.id)
    end
  end

  private

  def tracking_request
    Terminal49::TrackingRequest.create(
      request_type: REQUEST_TYPE,
      request_number: bill_of_lading,
      scac: scac
    )
  end
end
