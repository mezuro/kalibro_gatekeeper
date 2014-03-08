require 'spec_helper'

describe ConfigurationsController do
  describe 'exists' do
    before :each do
      KalibroGem::Entities::Configuration.expects(:exists?).with(42).returns(true)
    end

    context 'json format' do
      before :each do
        post :exists, id: 42, format: :json
      end

      it { should respond_with(:success) }

      it 'returns the list of names' do
        JSON.parse(response.body).should eq(JSON.parse({exists: true}.to_json))
      end
    end
  end
end
