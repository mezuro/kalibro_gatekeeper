require 'rails_helper'

describe MetricCollectorsController, :type => :controller do
  describe 'all_names' do
    before :each do
      KalibroProcessor.expects(:request).with("metric_collectors", {}, :get).returns({metric_collector_names: ["Analizo"]})
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
        expect(JSON.parse(response.body)).to eq(JSON.parse({metric_collector_names: ["Analizo"]}.to_json))
      end
    end
  end

  describe 'get' do
    let!(:metric_collector_hash) { Hash[FactoryGirl.attributes_for(:metric_collector).map { |k,v| [k.to_s, v.to_s]}] }

    context 'with and existent base tool' do
      before :each do
        metric_collector_hash["supported_metrics"] = {"code" => FactoryGirl.build(:metric)}
        KalibroProcessor.expects(:request).with("metric_collectors/#{metric_collector_hash["name"]}/find", {}, :get).returns({"metric_collector" => metric_collector_hash})
      end

      context 'json format' do
        before :each do
          post :get, name: metric_collector_hash["name"], format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns the base tool' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(metric_collector_hash.to_json))
        end
      end
    end

    context 'with an inexistent base tool' do
      let!(:metric_collector_name) {"MyBaseTool"}
      let!(:metric_collector_error) {{"error" => "Base tool #{metric_collector_name} not found."}}
      before :each do
        KalibroProcessor.expects(:request).with("metric_collectors/#{metric_collector_name}/find", {}, :get).returns(metric_collector_error)
      end
      context 'json format' do
        before :each do
          post :get, name: metric_collector_name, format: :json
        end

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns error' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(metric_collector_error.to_json))
        end
      end
    end
  end
end
