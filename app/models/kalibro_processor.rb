class KalibroProcessor

  def self.request(path, params = {}, method = :post)
    response = client.send(method) do |request|
      request.url "/#{path}"
      request.body = params
      request.options.timeout = 300
      request.options.open_timeout = 300
    end

    response.body
  end

  protected

  def self.address
    @@address ||= YAML.load_file("#{Rails.root}/config/kalibro_processor.yml")['address']
  end

  def self.client
    Faraday.new(:url => address) do |conn|
      conn.request :json
      conn.response :json, :content_type => /\bjson$/
      conn.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end
end