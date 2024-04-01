Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'fallook.com'

    resource '/api/v1/*',
      headers: :any,
      methods: [:get, :patch, :put, :delete, :post, :options]
  end
end