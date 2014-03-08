require 'spec_helper'

describe BaseToolsController do
  describe 'all_names' do
    before :each do
      KalibroGem::Entities::BaseTool.expects(:all_names).returns(["Analizo"])
    end

    context 'html format' do
      before :each do
        get :all_names
      end

      it { should respond_with(:success) }
    end

    context 'json format' do
      before :each do
        get :all_names, format: :json
      end

      it { should respond_with(:success) }

      it 'returns the list of names' do
        JSON.parse(response.body).should eq(JSON.parse({base_tool_names: ["Analizo"]}.to_json))
      end
    end
  end

  describe 'get' do
    let!(:base_tool) { FactoryGirl.build(:base_tool) }

    before :each do
      KalibroGem::Entities::BaseTool.expects(:find_by_name).with(base_tool.name).returns(base_tool)
    end

    context 'json format' do
      before :each do
        post :get, name: base_tool.name, format: :json
      end

      it { should respond_with(:success) }

      it 'returns the list of names' do
        JSON.parse(response.body).should eq(JSON.parse(base_tool.to_hash.to_json))
      end
    end
  end
end
