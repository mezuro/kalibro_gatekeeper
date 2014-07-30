require 'rails_helper'

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
      KalibroProcessor.expects(:request).with("metric_results/#{metric_result.id}/descendant_values", {}, :get).returns({descendant_results: metric_result.value})
    end

    context 'json format' do
      before :each do
        post :descendant_results_of, id: metric_result.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of values' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({descendant_results: metric_result.value}.to_json))
      end
    end
  end

  describe 'of' do
    let!(:module_result) { FactoryGirl.build(:module_result) }
    let!(:metric_result) { FactoryGirl.build(:metric_result) }
    let!(:metric_configuration) { FactoryGirl.build(:metric_configuration) }
    let!(:range) { FactoryGirl.build(:range) }
    let!(:reading) { FactoryGirl.build(:reading) }

    before :each do
      KalibroGem::Entities::MetricConfiguration.expects(:find).with(metric_result.metric_configuration_id).returns(metric_configuration)
      KalibroGem::Entities::Range.expects(:ranges_of).with(metric_result.metric_configuration_id).returns([range])
      KalibroGem::Entities::Reading.expects(:find).with(range.reading_id).returns(reading)
      KalibroProcessor.expects(:request).with("module_results/#{module_result.id}/metric_results", {}, :get).returns([Hash[metric_result.to_hash.map { |k,v| [k.to_s, v.to_s] }]])
    end

    context 'json format' do
      before :each do
        post :of, module_result_id: module_result.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of names' do
        pending "When the Prezento expectations get updated to the new processor this should pass"
        expect(JSON.parse(response.body)).to eq(JSON.parse({metric_results: [metric_result]}.to_json))
      end
    end
  end
end
