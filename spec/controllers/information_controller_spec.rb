require 'spec_helper'

describe InformationController do
  describe 'data' do
    describe 'html format' do
      before :each do
        get :data
      end

      it { should respond_with(:success) }
    end

    describe 'json format' do
      before :each do
        get :data, format: :json
      end

      it { should respond_with(:success) }

      it 'contains the information data' do
        JSON.parse(response.body).should eq(JSON.parse(Information.data.to_json))
      end
    end
  end
end
