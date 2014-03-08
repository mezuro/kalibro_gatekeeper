require 'spec_helper'

describe ModuleResultsController do
  describe 'get' do
    let(:module_result) { FactoryGirl.build(:module_result) }

    context 'with and existent module_result' do
      before :each do
        KalibroGem::Entities::ModuleResult.expects(:find).with(module_result.id).returns(module_result)
      end

      context 'json format' do
        before :each do
          post :get, id: module_result.id, format: :json
        end

        it { should respond_with(:success) }

        it 'returns module_result' do
          JSON.parse(response.body).should eq(JSON.parse(module_result.to_hash.to_json))
        end
      end
    end

    context 'with and inexistent module_result' do
      before :each do
        KalibroGem::Entities::ModuleResult.expects(:find).with(module_result.id).raises(KalibroGem::Errors::RecordNotFound)
      end

      context 'json format' do
        before :each do
          post :get, id: module_result.id, format: :json
        end

        it { should respond_with(:unprocessable_entity) }

        it 'returns module_result' do
          JSON.parse(response.body).should eq(JSON.parse({error: 'RecordNotFound'}.to_json))
        end
      end
    end
  end

  describe 'children_of' do
    let(:module_result) { FactoryGirl.build(:module_result) }

    context 'with and existent module_result' do
      let!(:children) { [FactoryGirl.build(:module_result, id: 63)] }

      before :each do
        module_result.expects(:children).returns(children)
        KalibroGem::Entities::ModuleResult.expects(:find).with(module_result.id).returns(module_result)
      end

      context 'json format' do
        before :each do
          post :children_of, id: module_result.id, format: :json
        end

        it { should respond_with(:success) }

        it 'returns module_result' do
          JSON.parse(response.body).should eq(JSON.parse({module_results: children.map { |c| c.to_hash }}.to_json))
        end
      end
    end

    context 'with and inexistent module_result' do
      before :each do
        KalibroGem::Entities::ModuleResult.expects(:find).with(module_result.id).raises(KalibroGem::Errors::RecordNotFound)
      end

      context 'json format' do
        before :each do
          post :children_of, id: module_result.id, format: :json
        end

        it { should respond_with(:unprocessable_entity) }

        it 'returns module_result' do
          JSON.parse(response.body).should eq(JSON.parse({error: 'RecordNotFound'}.to_json))
        end
      end
    end
  end
end
