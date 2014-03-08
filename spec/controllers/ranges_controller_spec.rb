require 'spec_helper'

describe RangesController do
  describe 'save' do
    let(:range) { FactoryGirl.build(:range, id: nil) }
    let(:range_params) { range.to_hash }

    context 'successfully saved' do
      before :each do
        KalibroGem::Entities::Range.any_instance.expects(:save).returns(true)
      end

      context 'json format' do
        before :each do
          range_params.delete(:attributes!)
          post :save, range: range_params, format: :json
        end

        it { should respond_with(:success) }

        it 'returns the range' do
          JSON.parse(response.body).should eq(JSON.parse(range.to_hash.to_json))
        end
      end
    end

    context 'failed to save' do
      before :each do
        KalibroGem::Entities::Range.any_instance.expects(:save).returns(false)
      end

      context 'json format' do
        before :each do
          range_params.delete(:attributes!)
          post :save, range: range_params, format: :json
        end

        it { should respond_with(:unprocessable_entity) }

        it 'returns range' do
          JSON.parse(response.body).should eq(JSON.parse(range.to_hash.to_json))
        end
      end
    end
  end

  describe 'destroy' do
    let(:range) { FactoryGirl.build(:range) }


    context 'with and existent range' do
      before :each do
        KalibroGem::Entities::Range.expects(:find).with(range.id).returns(range)
      end

      context 'json format' do
        before :each do
          range.expects(:detroy).returns(true)
          post :destroy, id: range.id, format: :json
        end

        it { should respond_with(:success) }

        it 'returns range' do
          JSON.parse(response.body).should eq(JSON.parse(range.to_hash.to_json))
        end
      end
    end

    context 'with and inexistent range' do
      before :each do
        KalibroGem::Entities::Range.expects(:find).with(range.id).raises(KalibroGem::Errors::RecordNotFound)
      end

      context 'json format' do
        before :each do
          post :destroy, id: range.id, format: :json
        end

        it { should respond_with(:unprocessable_entity) }

        it 'returns range' do
          JSON.parse(response.body).should eq(JSON.parse({error: 'RecordNotFound'}.to_json))
        end
      end
    end
  end

  describe 'of' do
    let!(:reading) {FactoryGirl.build(:reading)}
    let!(:ranges) { [FactoryGirl.build(:range)] }

    before :each do
      KalibroGem::Entities::Range.expects(:ranges_of).returns(ranges)
    end

    context 'json format' do
      before :each do
        get :of, reading_id: reading.id, format: :json
      end

      it { should respond_with(:success) }

      it 'returns the list of names' do
        JSON.parse(response.body).should eq(JSON.parse({ranges: ranges.map { |c| c.to_hash }}.to_json))
      end
    end
  end
end
