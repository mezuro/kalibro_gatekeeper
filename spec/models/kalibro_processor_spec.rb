require 'rails_helper'

describe KalibroProcessor, :type => :model do
  describe 'method' do
    let(:address) { 'http://test.test' }

    describe 'request' do
      let(:client) { mock('client') }
      let(:response) { mock('response') }

      it 'is expected to call the client post' do
        response.expects(:body).returns({exists: false})
        client.expects(:post).
          with('/kalibro_processor/exists', {id: 1}).
          returns(response)
        KalibroProcessor.expects(:client).returns(client)
        expect(KalibroProcessor.
          request('kalibro_processor/exists', {id: 1})[:exists]).to eq(false)
      end
    end

    describe 'address' do
      it 'is expected to load the YAML' do
        YAML.expects(:load_file).with("#{Rails.root}/config/kalibro_processor.yml").returns({'address' => address})
        expect(KalibroProcessor.address).to eq(address)
      end
    end

    describe 'client' do
      before :each do
        KalibroProcessor.expects(:address).returns(address)
      end

      it 'returns a Faraday::Connection' do
        expect(KalibroProcessor.client).to be_a(Faraday::Connection)
      end
    end
  end
end