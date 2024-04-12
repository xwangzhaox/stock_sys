module HttpRequest
  mattr_accessor :proxy_params
  # @@proxy_params = "-x socks://127.0.0.1:7890"
  @@curl_proxy = ""

  def self.curl_post_request_with_params(url, params, proxy: @@proxy_params)
    retries ||= 0
    response = `curl #{proxy} -X POST -d '#{params}' #{url}`
    response=='' ? (raise "URL request error!(url: #{url})") : JSON::parse(response)
  rescue StandardError => e
    retry if (retries += 1) < 3
    raise "URL request error!(url: #{url})"
  end
end