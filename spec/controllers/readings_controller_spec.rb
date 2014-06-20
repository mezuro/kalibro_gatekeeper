require 'rails_helper'

describe ReadingsController, :type => :controller do
  describe 'save' do
    let(:reading) { FactoryGirl.build(:reading, id: nil) }
    let(:reading_params) { reading.to_hash }

    context 'successfully saved' do
      before :each do
        KalibroGem::Entities::Reading.any_instance.expects(:save).returns(true)
      end

      context 'json format' do
        before :each do
          reading_params.delete(:attributes!)
          post :save, reading: reading_params, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns the reading' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(reading.to_hash.to_json))
        end
      end
    end

    context 'failed to save' do
      before :each do
        KalibroGem::Entities::Reading.any_instance.expects(:save).returns(false)
      end

      context 'json format' do
        before :each do
          reading_params.delete(:attributes!)
          post :save, reading: reading_params, format: :json
        end

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns reading' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(reading.to_hash.to_json))
        end
      end
    end
  end

  describe 'get' do
    let(:reading) { FactoryGirl.build(:reading) }

    context 'with and existent reading' do
      before :each do
        KalibroGem::Entities::Reading.expects(:find).with(reading.id).returns(reading)
      end

      context 'json format' do
        before :each do
          post :get, id: reading.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns reading' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(reading.to_hash.to_json))
        end
      end
    end

    context 'with and inexistent reading' do
      before :each do
        KalibroGem::Entities::Reading.expects(:find).with(reading.id).raises(KalibroGem::Errors::RecordNotFound)
      end

      context 'json format' do
        before :each do
          post :get, id: reading.id, format: :json
        end

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns reading' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({error: 'RecordNotFound'}.to_json))
        end
      end
    end
  end

  describe 'destroy' do
    let(:reading) { FactoryGirl.build(:reading) }

    context 'with and existent reading' do
      before :each do
        KalibroGem::Entities::Reading.expects(:find).with(reading.id).returns(reading)
      end

      context 'json format' do
        before :each do
          reading.expects(:destroy).returns(true)
          post :destroy, id: reading.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns reading' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(reading.to_hash.to_json))
        end
      end
    end

    context 'with and inexistent reading' do
      before :each do
        KalibroGem::Entities::Reading.expects(:find).with(reading.id).raises(KalibroGem::Errors::RecordNotFound)
      end

      context 'json format' do
        before :each do
          post :destroy, id: reading.id, format: :json
        end

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns reading' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({error: 'RecordNotFound'}.to_json))
        end
      end
    end
  end

  describe 'of' do
    let!(:reading_group) {FactoryGirl.build(:reading_group)}
    let!(:readings) { [FactoryGirl.build(:reading)] }

    before :each do
      KalibroGem::Entities::Reading.expects(:readings_of).returns(readings)
    end

    context 'json format' do
      before :each do
        get :of, reading_group_id: reading_group.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of names' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({readings: readings.map { |c| c.to_hash }}.to_json))
      end
    end
  end
end
