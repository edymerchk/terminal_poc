module RequestHelpers
  def header_with_terminal_signature(payload)
    signature = OpenSSL::HMAC.hexdigest('SHA256', Terminal49.webhook_secret, Rack::Utils.build_nested_query(payload))

    { "X-T49-Webhook-Signature" => signature }
  end

  def jsonapi_headers
    { "Content-Type"  => "application/vnd.api+json" }
  end

  def json_response
    JSON.parse(response.body).with_indifferent_access
  end
end
