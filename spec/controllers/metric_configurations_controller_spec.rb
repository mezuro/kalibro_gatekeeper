require 'spec_helper'

describe MetricConfigurationsController do
  describe 'save' do
    let(:metric_configuration) { FactoryGirl.build(:metric_configuration, id: nil) }
    let(:metric_configuration_params) { metric_configuration.to_hash }

    context 'successfully saved' do
      before :each do
        KalibroGem::Entities::MetricConfiguration.any_instance.expects(:save).returns(true)
      end

      context 'json format' do
        before :each do
          metric_configuration_params.delete(:attributes!)
          post :save, metric_configuration: metric_configuration_params, format: :json
        end

        it { should respond_with(:success) }

        it 'returns the metric_configuration' do
          JSON.parse(response.body).should eq(JSON.parse(metric_configuration.to_hash.to_json))
        end
      end
    end

    context 'failed to save' do
      before :each do
        KalibroGem::Entities::MetricConfiguration.any_instance.expects(:save).returns(false)
      end

      context 'json format' do
        before :each do
          metric_configuration_params.delete(:attributes!)
          post :save, metric_configuration: metric_configuration_params, format: :json
        end

        it { should respond_with(:unprocessable_entity) }

        it 'returns metric_configuration' do
          JSON.parse(response.body).should eq(JSON.parse(metric_configuration.to_hash.to_json))
        end
      end
    end
  end

  describe 'get' do
    let(:metric_configuration) { FactoryGirl.build(:metric_configuration) }

    context 'with and existent metric_configuration' do
      before :each do
        KalibroGem::Entities::MetricConfiguration.expects(:find).with(metric_configuration.id).returns(metric_configuration)
      end

      context 'json format' do
        before :each do
          post :get, id: metric_configuration.id, format: :json
        end

        it { should respond_with(:success) }

        it 'returns metric_configuration' do
          JSON.parse(response.body).should eq(JSON.parse(metric_configuration.to_hash.to_json))
        end
      end
    end

    context 'with and inexistent metric_configuration' do
      before :each do
        KalibroGem::Entities::MetricConfiguration.expects(:find).with(metric_configuration.id).raises(KalibroGem::Errors::RecordNotFound)
      end

      context 'json format' do
        before :each do
          post :get, id: metric_configuration.id, format: :json
        end

        it { should respond_with(:unprocessable_entity) }

        it 'returns metric_configuration' do
          JSON.parse(response.body).should eq(JSON.parse({error: 'RecordNotFound'}.to_json))
        end
      end
    end
  end

  describe 'destroy' do
    let(:metric_configuration) { FactoryGirl.build(:metric_configuration) }


    context 'with and existent metric_configuration' do
      before :each do
        KalibroGem::Entities::MetricConfiguration.expects(:find).with(metric_configuration.id).returns(metric_configuration)
      end

      context 'json format' do
        before :each do
          metric_configuration.expects(:destroy).returns(true)
          post :destroy, id: metric_configuration.id, format: :json
        end

        it { should respond_with(:success) }

        it 'returns metric_configuration' do
          JSON.parse(response.body).should eq(JSON.parse(metric_configuration.to_hash.to_json))
        end
      end
    end

    context 'with and inexistent metric_configuration' do
      before :each do
        KalibroGem::Entities::MetricConfiguration.expects(:find).with(metric_configuration.id).raises(KalibroGem::Errors::RecordNotFound)
      end

      context 'json format' do
        before :each do
          post :destroy, id: metric_configuration.id, format: :json
        end

        it { should respond_with(:unprocessable_entity) }

        it 'returns metric_configuration' do
          JSON.parse(response.body).should eq(JSON.parse({error: 'RecordNotFound'}.to_json))
        end
      end
    end
  end

  describe 'of' do
    let!(:configuration) {FactoryGirl.build(:configuration)}
    let!(:metric_configurations) { [FactoryGirl.build(:metric_configuration)] }

    before :each do
      KalibroGem::Entities::MetricConfiguration.expects(:metric_configurations_of).returns(metric_configurations)
    end

    context 'json format' do
      before :each do
        get :of, configuration_id: configuration.id, format: :json
      end

      it { should respond_with(:success) }

      it 'returns the list of names' do
        JSON.parse(response.body).should eq(JSON.parse({metric_configurations: metric_configurations.map { |c| c.to_hash }}.to_json))
      end
    end
  end
end
