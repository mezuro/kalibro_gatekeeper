require 'spec_helper'

describe ConfigurationsController do
  describe 'exists' do
    before :each do
      KalibroGem::Entities::Configuration.expects(:exists?).with(42).returns(true)
    end

    context 'json format' do
      before :each do
        post :exists, id: 42, format: :json
      end

      it { should respond_with(:success) }

      it 'returns the list of names' do
        JSON.parse(response.body).should eq(JSON.parse({exists: true}.to_json))
      end
    end
  end

  describe 'exists' do
    let!(:configurations) { [FactoryGirl.build(:configuration), FactoryGirl.build(:another_configuration)] }

    before :each do
      KalibroGem::Entities::Configuration.expects(:all).returns(configurations)
    end

    context 'html format' do
      before :each do
        get :all
      end

      it { should respond_with(:success) }
    end

    context 'json format' do
      before :each do
        get :all, format: :json
      end

      it { should respond_with(:success) }

      it 'returns the list of names' do
        JSON.parse(response.body).should eq(JSON.parse({configurations: configurations.map { |c| c.to_hash }}.to_json))
      end
    end
  end

  describe 'save' do
    let(:configuration) { FactoryGirl.build(:configuration, id: nil) }

    context 'successfully saved' do
      before :each do
        KalibroGem::Entities::Configuration.any_instance.expects(:save).returns(true)
      end

      context 'json format' do
        before :each do
          post :save, configuration: configuration.to_hash, format: :json
        end

        it { should respond_with(:success) }

        it 'returns the configuration' do
          JSON.parse(response.body).should eq(JSON.parse(configuration.to_hash.to_json))
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

        it { should respond_with(:unprocessable_entity) }

        it 'returns configuration' do
          JSON.parse(response.body).should eq(JSON.parse(configuration.to_hash.to_json))
        end
      end
    end
  end
end
