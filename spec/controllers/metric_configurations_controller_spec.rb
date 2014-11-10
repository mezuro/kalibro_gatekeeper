require 'rails_helper'

describe MetricConfigurationsController, :type => :controller do
  pending 'In development' do
    describe 'save' do
      context 'with a native metric' do
        let(:metric_configuration) { FactoryGirl.build(:metric_configuration, id: 0) }
        let(:metric_configuration_params) { metric_configuration.to_hash }

        context 'successfully saved' do
          before :each do
            KalibroGem::Entities::MetricConfiguration.any_instance.expects(:save).returns(true)
          end

          context 'json format' do
            before :each do
              metric_configuration_params[:metric_collector_name] = metric_configuration_params.delete(:base_tool_name)
              post :save, metric_configuration: metric_configuration_params, format: :json
            end

            it { is_expected.to respond_with(:success) }

            it 'returns the metric_configuration' do
              expect(metric_configuration_params["id"]).to eq(nil)
              expect(JSON.parse(response.body)).to eq(JSON.parse(metric_configuration_params.to_json))
            end
          end
        end

        context 'failed to save' do
          before :each do
            KalibroGem::Entities::MetricConfiguration.any_instance.expects(:save).returns(false)
          end

          context 'json format' do
            before :each do
              metric_configuration_params[:metric_collector_name] = metric_configuration_params.delete(:base_tool_name)
              post :save, metric_configuration: metric_configuration_params, format: :json
            end

            it { is_expected.to respond_with(:unprocessable_entity) }

            it 'returns metric_configuration' do
              expect(metric_configuration_params["id"]).to eq(nil)
              expect(JSON.parse(response.body)).to eq(JSON.parse(metric_configuration.to_hash.to_json))
            end
          end
        end
      end

      context 'with a compound metric' do
        let(:metric_configuration) { FactoryGirl.build(:metric_configuration, id: 0, metric: FactoryGirl.build(:compound_metric)) }
        let(:metric_configuration_params) { metric_configuration.to_hash }

        context 'successfully saved' do
          before :each do
            KalibroGem::Entities::MetricConfiguration.any_instance.expects(:save).returns(true)
          end

          context 'json format' do
            before :each do
              metric_configuration_params[:metric_collector_name] = metric_configuration_params.delete(:base_tool_name)
              post :save, metric_configuration: metric_configuration_params, format: :json
            end

            it { is_expected.to respond_with(:success) }

            it 'returns the metric_configuration' do
              expect(metric_configuration_params["id"]).to eq(nil)
              expect(JSON.parse(response.body)).to eq(JSON.parse(metric_configuration_params.to_json))
            end
          end
        end
      end

      describe 'get' do
        let(:metric_configuration) { FactoryGirl.build(:metric_configuration) }
        let(:metric_configuration_params) { Hash[FactoryGirl.attributes_for(:metric_configuration).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with symbols and integers
        context 'with an existent metric_configuration' do
          before :each do
            metric_configuration_params.delete("metric")
            metric_configuration_params.delete("code")
            metric_configuration_params["kalibro_configuration_id"] = metric_configuration_params.delete("configuration_id")
            KalibroConfiguration.expects(:request).with("metric_configurations/#{metric_configuration.id}", {}, :get).returns({"metric_configuration" => metric_configuration_params})
          end

          context 'json format' do
            before :each do
              post :get, id: metric_configuration.id, format: :json
            end

            it { is_expected.to respond_with(:success) }

            it 'returns the metric_configuration' do
              metric_configuration_hash = metric_configuration.to_hash
              metric_configuration_hash.delete(:metric)
              metric_configuration_hash.delete(:attributes!)
              metric_configuration_hash.delete(:kalibro_errors)
              metric_configuration_hash.delete(:code)
              metric_configuration_hash["configuration_id"] = metric_configuration.configuration_id.to_s
              #expected[:metric_collector_name] = expected.delete(:base_tool_name)
              expect(JSON.parse(response.body)).to eq(JSON.parse(metric_configuration_hash.to_json))
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

            it { is_expected.to respond_with(:unprocessable_entity) }

            it 'returns metric_configuration' do
              expect(JSON.parse(response.body)).to eq(JSON.parse({error: 'RecordNotFound'}.to_json))
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

            it { is_expected.to respond_with(:success) }

            it 'returns metric_configuration' do
              expected = metric_configuration.to_hash
              expected[:metric_collector_name] = expected.delete(:base_tool_name)
              expect(JSON.parse(response.body)).to eq(JSON.parse(expected.to_json))
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

            it { is_expected.to respond_with(:unprocessable_entity) }

            it 'returns metric_configuration' do
              expect(JSON.parse(response.body)).to eq(JSON.parse({error: 'RecordNotFound'}.to_json))
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

          it { is_expected.to respond_with(:success) }

          it 'returns the list of names' do
            metric_configurations_hash = metric_configurations.map { |c| c.to_hash }
            metric_configurations_hash.each { |c| c[:metric_collector_name] = c.delete(:base_tool_name)}
            expect(JSON.parse(response.body)).to eq(JSON.parse({metric_configurations: metric_configurations_hash}.to_json))
          end
        end
      end
    end
  end
end
