class V1::RequestsController < ApplicationController
  deserializable_resource :request

  def create
    request = RequestCreator.new(request_params).create!
    render jsonapi: request, status: :created
  end

  private

  def request_params
    params.require(:request).permit(:bill_of_lading, :scac)
  end
end
