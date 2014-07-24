require 'rails_helper'

describe ModuleResultsController, :type => :controller do
  describe 'get' do
    let!(:module_hash) { Hash[FactoryGirl.attributes_for(:module).map { |k,v| [k.to_s, v.to_s]}] }
    let!(:module_result_hash) { Hash[FactoryGirl.attributes_for(:module_result).map { |k,v| [k.to_s, v.to_s]}] }

    context 'with and existent module_result' do
      before :each do
        module_result_hash["module"] = module_hash
        KalibroProcessor.expects(:request).with("module_results/#{module_result_hash["id"]}/get", {}, :get).returns(module_result_hash)
      end

      context 'json format' do
        before :each do
          post :get, id: module_result_hash["id"], format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns module_result' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(module_result_hash.to_json))
        end
      end
    end

    context 'with and inexistent module_result' do
      let!(:error_hash) {{"error"=> "RecordNotFound"}}
      before :each do
        KalibroProcessor.expects(:request).with("module_results/#{module_result_hash["id"]}/get", {}, :get).returns(error_hash)
      end

      context 'json format' do
        before :each do
          post :get, id: module_result_hash["id"], format: :json
        end

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns error hash' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(error_hash.to_json))
        end
      end
    end
  end
  describe 'children_of' do
    let!(:module_hash) { Hash[FactoryGirl.attributes_for(:module).map { |k,v| [k.to_s, v.to_s]}] }
    let!(:module_result_hash) { Hash[FactoryGirl.attributes_for(:module_result).map { |k,v| [k.to_s, v.to_s]}] }
    let!(:children) { [] }

    context 'with and existent module_result' do
      before :each do
        module_result_hash["module"] = module_hash
        children << module_result_hash
        children << module_result_hash
        KalibroProcessor.expects(:request).with("module_results/#{module_result_hash["id"]}/children", {}, :get).returns(children)
      end

      context 'json format' do
        before :each do
          post :children_of, id: module_result_hash["id"], format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns children' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({module_results: children.map { |c| c.to_hash }}.to_json))
        end
      end
    end

    context 'with and inexistent module_result' do
      let!(:error_hash) {{"error"=> "RecordNotFound"}}
      before :each do
        KalibroProcessor.expects(:request).with("module_results/#{module_result_hash["id"]}/children", {}, :get).returns(error_hash)
      end

      context 'json format' do
        before :each do
          post :children_of, id: module_result_hash["id"], format: :json
        end

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns module_result' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(error_hash.to_json))
        end
      end
    end
  end
  describe 'history_of' do
    let!(:module_result) { FactoryGirl.build(:module_result) }
    let!(:date_module_results) { [FactoryGirl.build(:date_module_result)] }

    before :each do
      KalibroGem::Entities::ModuleResult.expects(:history_of).with(module_result.id).returns(date_module_results)
    end

    context 'json format' do
      before :each do
        post :history_of, id: module_result.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of date_metric_results' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({date_module_results: date_module_results.map { |date_module_result| date_module_result.to_hash }}.to_json))
      end
    end
  end
end
