require 'rails_helper'

describe ReadingGroupsController, :type => :controller do
  describe 'exists' do
    before :each do
      KalibroConfiguration.expects(:request).with("reading_groups/42/exists", {}, :get).returns(exists: true)
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
    let!(:reading_groups) { [FactoryGirl.build(:reading_group).to_hash, FactoryGirl.build(:reading_group, name: 'testtest').to_hash] }

    before :each do
      KalibroConfiguration.expects(:request).with("reading_groups", {}, :get).returns("reading_groups" => reading_groups)
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

    context 'when creating a new reading_group' do
      let(:reading_group) { FactoryGirl.build(:reading_group, id: nil) }

      context 'successfully saved' do
        before :each do
          reading_group_params = {}
          reading_group.to_hash.select { | k, v |  k != :id }.map { |k, v| reading_group_params[k.to_s] = v }
          KalibroConfiguration.expects(:request).with("reading_groups", {reading_group: reading_group_params}).returns('reading_group' => reading_group.to_hash)
        end

        context 'json format' do
          before :each do
            post :save, reading_group: reading_group.to_hash, format: :json
          end

          it { is_expected.to respond_with(:success) }

          it 'returns the reading_group' do
            expect(JSON.parse(response.body)).to eq(JSON.parse(reading_group.to_json))
          end
        end
      end

      context 'failed to save' do
        before :each do
          reading_group_params = {}
          reading_group.to_hash.select { | k, v |  k != :id }.map { |k, v| reading_group_params[k.to_s] = v }
          return_reading_group_params = reading_group_params.clone
          return_reading_group_params["errors"] = ["Error"]
          KalibroConfiguration.expects(:request).with("reading_groups", {reading_group: reading_group_params}).returns('reading_group' => return_reading_group_params)
        end

        context 'json format' do
          before :each do
            post :save, reading_group: reading_group.to_hash, format: :json
          end

          it { is_expected.to respond_with(:unprocessable_entity) }

          it 'returns reading_group' do
            expected_return = JSON.parse(reading_group.to_hash.to_json)
            expected_return["kalibro_errors"] = ["Error"]
            expected_return.delete("id")
            expect(JSON.parse(response.body)).to eq(expected_return)
          end
        end
      end
    end

    context 'when updating a existing reading_group' do
      let(:reading_group) { FactoryGirl.build(:reading_group, id: 42) }

      context 'successfully saved' do
        before :each do
          reading_group_params = {}
          reading_group.to_hash.select { | k, v |  k != :id }.map { |k, v| reading_group_params[k.to_s] = v }
          KalibroConfiguration.expects(:request).with("reading_groups/#{reading_group.id}", {reading_group: reading_group_params}, :put).returns('reading_group' => reading_group.to_hash)
        end

        context 'json format' do
          before :each do
            post :save, reading_group: reading_group.to_hash, format: :json
          end

          it { is_expected.to respond_with(:success) }

          it 'returns the reading_group' do
            expect(JSON.parse(response.body)).to eq(JSON.parse(reading_group.to_json))
          end
        end
      end

      context 'failed to save' do
        before :each do
          reading_group_params = {}
          reading_group.to_hash.select { | k, v |  k != :id }.map { |k, v| reading_group_params[k.to_s] = v }
          return_reading_group_params = reading_group_params.clone
          return_reading_group_params["errors"] = ["Error"]
          KalibroConfiguration.expects(:request).with("reading_groups/#{reading_group.id}", {reading_group: reading_group_params}, :put).returns('reading_group' => return_reading_group_params)
        end

        context 'json format' do
          before :each do
            post :save, reading_group: reading_group.to_hash, format: :json
          end

          it { is_expected.to respond_with(:unprocessable_entity) }

          it 'returns reading_group' do
            expected_return = JSON.parse(reading_group.to_hash.to_json)
            expected_return["kalibro_errors"] = ["Error"]
            expected_return.delete("id")
            expect(JSON.parse(response.body)).to eq(expected_return)
          end
        end
      end
    end
  end

  describe 'get' do
    let(:reading_group) { FactoryGirl.build(:reading_group) }

    context 'with and existent reading_group' do
      before :each do
        KalibroConfiguration.expects(:request).with("reading_groups/#{reading_group.id}", {}, :get).returns("reading_group" => reading_group)
      end

      context 'json format' do
        before :each do
          post :get, id: reading_group.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns reading_group' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(reading_group.to_json))
        end
      end
    end

    context 'with and inexistent reading_group' do
      before :each do
        KalibroConfiguration.expects(:request).with("reading_groups/#{reading_group.id}", {}, :get).returns("error" => 'RecordNotFound')
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
        KalibroConfiguration.expects(:request).with("reading_groups/#{reading_group.id}", {}, :delete).returns({})
      end

      context 'json format' do
        before :each do
          post :destroy, id: reading_group.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns reading_group' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({}.to_json))
        end
      end
    end
  end
end
