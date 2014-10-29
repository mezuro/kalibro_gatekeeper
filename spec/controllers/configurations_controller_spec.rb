require 'rails_helper'

describe ConfigurationsController, :type => :controller do
  describe 'exists' do
    before :each do
      KalibroConfiguration.expects(:request).with("kalibro_configurations/42/exists", {}, :get).returns(exists: true)
    end

    context 'json format' do
      before :each do
        post :exists, id: 42, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of names' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({exists: true}.to_json))
      end
    end
  end

  describe 'all' do
    let!(:configurations) { [FactoryGirl.build(:configuration), FactoryGirl.build(:another_configuration)] }

    before :each do
      KalibroConfiguration.expects(:request).with("kalibro_configurations", {}, :get).returns(kalibro_configurations: configurations)
    end

    context 'html format' do
      before :each do
        get :all
      end

      it { is_expected.to respond_with(:success) }
    end

    context 'json format' do
      before :each do
        get :all, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of names' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({configurations: configurations.map { |c| c.to_hash }}.to_json))
      end
    end
  end

=begin
  describe 'save' do
    let(:configuration) { FactoryGirl.build(:configuration, id: nil) }

    context 'successfully saved' do
      before :each do
        configuration_params = {}
        configuration.to_hash.select { | k, v |  k != :id }.map { |k, v| configuration_params[k.to_s] = v }
        KalibroConfiguration.expects(:request).with("kalibro_configurations", {kalibro_configuration: configuration_params}).returns(kalibro_configuration: configuration)
      end

      context 'json format' do
        before :each do
          post :save, configuration: configuration.to_hash, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns the configuration' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({kalibro_configuration: configuration}.to_json))
        end
      end
    end

    context 'failed to save' do
      before :each do
        KalibroGem::Entities::Configuration.any_instance.expects(:save).returns(false)
      end

      context 'json format' do
        before :each do
          post :save, configuration: configuration.to_hash, format: :json
        end

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns configuration' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(configuration.to_hash.to_json))
        end
      end
    end
  end
=end
  describe 'get' do
    let(:configuration) { FactoryGirl.build(:configuration) }

    context 'with and existent configuration' do
      before :each do
        KalibroConfiguration.expects(:request).with("kalibro_configurations/#{configuration.id}", {}, :get).returns(kalibro_configuration: configuration)
      end

      context 'json format' do
        before :each do
          post :get, id: configuration.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns configuration' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({kalibro_configuration: configuration}.to_json))
        end
      end
    end

    context 'with and inexistent configuration' do
      before :each do
        KalibroConfiguration.expects(:request).with("kalibro_configurations/#{configuration.id}", {}, :get).returns(error: 'RecordNotFound')
      end

      context 'json format' do
        before :each do
          post :get, id: configuration.id, format: :json
        end

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns configuration' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({error: 'RecordNotFound'}.to_json))
        end
      end
    end
  end

  describe 'destroy' do
    let(:configuration) { FactoryGirl.build(:configuration) }


    context 'with and existent configuration' do
      before :each do
        KalibroConfiguration.expects(:request).with("kalibro_configurations/#{configuration.id}", {}, :delete).returns({})
      end

      context 'json format' do
        before :each do
          post :destroy, id: configuration.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns configuration' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({}.to_json))
        end
      end
    end
  end
end
