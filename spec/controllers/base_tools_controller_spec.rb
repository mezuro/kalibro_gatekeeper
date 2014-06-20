require 'spec_helper'

describe BaseToolsController, :type => :controller do
  describe 'all_names' do
    before :each do
      KalibroGem::Entities::BaseTool.expects(:all_names).returns(["Analizo"])
    end

    context 'html format' do
      before :each do
        get :all_names
      end

      it { is_expected.to respond_with(:success) }
    end

    context 'json format' do
      before :each do
        get :all_names, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of names' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({base_tool_names: ["Analizo"]}.to_json))
      end
    end
  end

  describe 'get' do
    let!(:base_tool) { FactoryGirl.build(:base_tool) }

    context 'with and existent base tool' do
      before :each do
        KalibroGem::Entities::BaseTool.expects(:find_by_name).with(base_tool.name).returns(base_tool)
      end

      context 'json format' do
        before :each do
          post :get, name: base_tool.name, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns the list of names' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(base_tool.to_hash.to_json))
        end
      end
    end

    context 'with and inexistent base tool' do
      before :each do
        KalibroGem::Entities::BaseTool.expects(:find_by_name).with("MyBaseTool").raises(KalibroGem::Errors::RecordNotFound)
      end

      context 'json format' do
        before :each do
          post :get, name: "MyBaseTool", format: :json
        end

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns configuration' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({error: 'RecordNotFound'}.to_json))
        end
      end
    end
  end
end
