class WebhooksController < ApplicationController
  def create
    return head :bad_request unless valid_signature?(request)

    case event_type
    when 'tracking_request.succeeded'
      UpdateRequest.new(tracking_request_id, containers).call
    end

    head :ok
  end

  private

  def event_type
    params.require(:data).require(:attributes).require(:event)
  end

  def tracking_request_id
    params.require(:data).require(:relationships).require(:reference_object).require(:data).require(:id)
  end

  def containers
    params.require(:included).select {|e| e['type'] == 'container'}
  end

  def valid_signature?(request)
    signature = OpenSSL::HMAC.hexdigest('SHA256', Terminal49.webhook_secret, request.body.read)
    request.headers['X-T49-Webhook-Signature'] == signature
  end
end
