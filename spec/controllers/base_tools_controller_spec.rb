require 'rails_helper'

describe BaseToolsController, :type => :controller do
  describe 'all_names' do
    before :each do
      KalibroProcessor.expects(:request).with("base_tools", {}, :get).returns({base_tool_names: ["Analizo"]})
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
    let!(:base_tool_hash) { FactoryGirl.build(:base_tool).to_hash }

    context 'with and existent base tool' do
      before :each do
        KalibroProcessor.expects(:request).with("base_tools/#{base_tool_hash[:name]}/find", {}, :get).returns({base_tool: base_tool_hash})
      end

      context 'json format' do
        before :each do
          post :get, name: base_tool_hash[:name], format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns the base tool' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({base_tool: base_tool_hash}.to_json))
        end
      end
    end
    context 'with an inexistent base tool' do
      let!(:base_tool_name) {"MyBaseTool"}
      let!(:base_tool_error) {{error: "Base tool #{base_tool_name} not found."}}
      before :each do
        KalibroProcessor.expects(:request).with("base_tools/#{base_tool_name}/find", {}, :get).returns(base_tool_error)
      end
      context 'json format' do
        before :each do
          post :get, name: base_tool_name, format: :json
        end

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns error' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(base_tool_error.to_json))
        end
      end
    end
  end
end
