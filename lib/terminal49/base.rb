module Terminal49
  mattr_accessor :webhook_secret, instance_reader: false

  class Base < JsonApiClient::Resource
    self.site = ENV.fetch('TERMINAL_API_URL')
  end

  def self.configure
    yield self
  end
end

Terminal49::Base.connection do |connection|
  connection.faraday.request :authorization, :Token, token: ENV.fetch("API_TOKEN")
  connection.faraday.request :json
  connection.faraday.response :raise_error
end
