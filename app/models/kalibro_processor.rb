class KalibroProcessor

  def self.request(path, params = {}, method = :post)
    client.send(method, "/#{path}", params).body
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