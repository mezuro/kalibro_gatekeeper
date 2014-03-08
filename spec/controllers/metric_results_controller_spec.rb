require 'spec_helper'

describe MetricResultsController do
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

      it { should respond_with(:success) }

      it 'returns the list of names' do
        JSON.parse(response.body).should eq(JSON.parse({date_metric_results: date_metric_results.map { |date_metric_result| date_metric_result.to_hash }}.to_json))
      end
    end
  end

  describe 'descendant_results_of' do
    let!(:metric_result) { FactoryGirl.build(:metric_result) }
    before :each do
      KalibroGem::Entities::MetricResult.expects(:descendant_results).with(metric_result.id).returns([metric_result.value])
    end

    context 'json format' do
      before :each do
        post :descendant_results_of, id: metric_result.id, format: :json
      end

      it { should respond_with(:success) }

      it 'returns the list of names' do
        JSON.parse(response.body).should eq(JSON.parse({descendant_results: [metric_result.value]}.to_json))
      end
    end
  end
end
