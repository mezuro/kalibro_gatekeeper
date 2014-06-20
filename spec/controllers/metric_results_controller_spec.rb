require 'spec_helper'

describe MetricResultsController, :type => :controller do
  describe 'history_of_metric' do
    let!(:metric) { FactoryGirl.build(:metric) }
    let!(:module_result) { FactoryGirl.build(:module_result) }
    let!(:date_metric_results) { [FactoryGirl.build(:date_metric_result), FactoryGirl.build(:another_date_metric_result)] }

    before :each do
      KalibroGem::Entities::MetricResult.expects(:history_of).with(metric.name, module_result.id).returns(date_metric_results)
    end

    context 'json format' do
      before :each do
        post :history_of_metric, metric_name: metric.name, module_result_id: module_result.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of date_metric_results' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({date_metric_results: date_metric_results.map { |date_metric_result| date_metric_result.to_hash }}.to_json))
      end
    end
  end

  describe 'descendant_results_of' do
    let!(:metric_result) { FactoryGirl.build(:metric_result) }

    before :each do
      KalibroGem::Entities::MetricResult.any_instance.expects(:descendant_results).returns([metric_result.value])
    end

    context 'json format' do
      before :each do
        post :descendant_results_of, id: metric_result.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of values' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({descendant_results: [metric_result.value]}.to_json))
      end
    end
  end

  describe 'of' do
    let!(:module_result) { FactoryGirl.build(:module_result) }
    let!(:metric_result) { FactoryGirl.build(:metric_result) }

    before :each do
      KalibroGem::Entities::MetricResult.expects(:metric_results_of).with(module_result.id).returns([metric_result.to_hash])
    end

    context 'json format' do
      before :each do
        post :of, module_result_id: module_result.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of names' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({metric_results: [metric_result.to_hash]}.to_json))
      end
    end
  end
end
