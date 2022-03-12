require "terminal49"

return unless Rails.env.development?

# Uncomment the following line to clean the existing webhooks
# Terminal49::Webhook.all.each(&:destroy)

ngrok_host = ENV.fetch("NGROK_HOST") do
  raise "🔥 Set NGROK_HOST environment variable"
end

webhook_url = "#{ngrok_host}/webhooks"

webhook = Terminal49::Webhook.all.find { |wb| wb.url == webhook_url }
webhook ||= Terminal49::Webhook.create(
  url: webhook_url,
  active: true,
  events: [
    "tracking_request.succeeded"
  ]
)

Terminal49.configure do |config|
  config.webhook_secret = webhook.secret
end

Rails.logger.info "Webhook for terminal49 successfully set on #{webhook_url}"

