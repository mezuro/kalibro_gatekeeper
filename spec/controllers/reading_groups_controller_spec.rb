require 'spec_helper'

describe ReadingGroupsController, :type => :controller do
  describe 'exists' do
    before :each do
      KalibroGem::Entities::ReadingGroup.expects(:exists?).with(42).returns(true)
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
    let!(:reading_groups) { [FactoryGirl.build(:reading_group)] }

    before :each do
      KalibroGem::Entities::ReadingGroup.expects(:all).returns(reading_groups)
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
        expect(JSON.parse(response.body)).to eq(JSON.parse({reading_groups: reading_groups.map { |c| c.to_hash }}.to_json))
      end
    end
  end

  describe 'save' do
    let(:reading_group) { FactoryGirl.build(:reading_group, id: nil) }

    context 'successfully saved' do
      before :each do
        KalibroGem::Entities::ReadingGroup.any_instance.expects(:save).returns(true)
      end

      context 'json format' do
        before :each do
          post :save, reading_group: reading_group.to_hash, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns the reading_group' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(reading_group.to_hash.to_json))
        end
      end
    end

    context 'failed to save' do
      before :each do
        KalibroGem::Entities::ReadingGroup.any_instance.expects(:save).returns(false)
      end

      context 'json format' do
        before :each do
          post :save, reading_group: reading_group.to_hash, format: :json
        end

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns reading_group' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(reading_group.to_hash.to_json))
        end
      end
    end
  end

  describe 'get' do
    let(:reading_group) { FactoryGirl.build(:reading_group) }


    context 'with and existent reading_group' do
      before :each do
        KalibroGem::Entities::ReadingGroup.expects(:find).with(reading_group.id).returns(reading_group)
      end

      context 'json format' do
        before :each do
          post :get, id: reading_group.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns reading_group' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(reading_group.to_hash.to_json))
        end
      end
    end

    context 'with and inexistent reading_group' do
      before :each do
        KalibroGem::Entities::ReadingGroup.expects(:find).with(reading_group.id).raises(KalibroGem::Errors::RecordNotFound)
      end

      context 'json format' do
        before :each do
          post :get, id: reading_group.id, format: :json
        end

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns reading_group' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({error: 'RecordNotFound'}.to_json))
        end
      end
    end
  end

  describe 'destroy' do
    let(:reading_group) { FactoryGirl.build(:reading_group) }


    context 'with and existent reading_group' do
      before :each do
        KalibroGem::Entities::ReadingGroup.expects(:find).with(reading_group.id).returns(reading_group)
      end

      context 'json format' do
        before :each do
          reading_group.expects(:destroy).returns(true)
          post :destroy, id: reading_group.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns reading_group' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(reading_group.to_hash.to_json))
        end
      end
    end

    context 'with and inexistent reading_group' do
      before :each do
        KalibroGem::Entities::ReadingGroup.expects(:find).with(reading_group.id).raises(KalibroGem::Errors::RecordNotFound)
      end

      context 'json format' do
        before :each do
          post :destroy, id: reading_group.id, format: :json
        end

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns reading_group' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({error: 'RecordNotFound'}.to_json))
        end
      end
    end
  end
end
