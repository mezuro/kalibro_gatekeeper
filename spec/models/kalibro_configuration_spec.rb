require 'rails_helper'

describe KalibroConfiguration, :type => :model do
  describe 'method' do
    let(:address) { 'http://test.test' }

    describe 'request' do
      let(:client) { mock('client') }
      let(:response) { mock('response') }
      let(:request) { mock('request') }
      let(:options) { mock('options') }

      it 'is expected to call the client post' do
        options.expects(:timeout=)
        options.expects(:open_timeout=)
        request.expects(:url).with('/kalibro_configuration/exists')
        request.expects(:body=).with({id: 1})
        request.expects(:options).twice.returns(options)
        response.expects(:body).returns({exists: false})
        client.expects(:post).
          yields(request).
          returns(response)
        KalibroConfiguration.expects(:client).returns(client)
        expect(KalibroConfiguration.
          request('kalibro_configuration/exists', {id: 1})[:exists]).to eq(false)
      end
    end

    describe 'address' do
      it 'is expected to load the YAML' do
        YAML.expects(:load_file).with("#{Rails.root}/config/kalibro_configuration.yml").returns({'address' => address})
        expect(KalibroConfiguration.address).to eq(address)
      end
    end

    describe 'client' do
      before :each do
        KalibroConfiguration.expects(:address).returns(address)
      end

      it 'returns a Faraday::Connection' do
        expect(KalibroConfiguration.client).to be_a(Faraday::Connection)
      end
    end
  end
end