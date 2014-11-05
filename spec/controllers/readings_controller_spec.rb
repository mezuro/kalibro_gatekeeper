require 'rails_helper'

describe ReadingsController, :type => :controller do
  describe 'save' do
    describe 'create' do
      let(:reading) { FactoryGirl.build(:reading) }
      let(:reading_params) { Hash[FactoryGirl.attributes_for(:reading, id: nil).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with symbols and integers }

      context 'successfully created' do
        before :each do
          reading_params.delete("id")
          KalibroConfiguration.expects(:request).with("reading_groups/#{reading.group_id}/readings", {reading: reading_params}).returns({"reading" => reading_params})
        end

        context 'json format' do
          before :each do
            post :save, reading: reading_params, format: :json
          end

          it { is_expected.to respond_with(:success) }

          it 'returns the reading' do
            expect(JSON.parse(response.body)).to eq(JSON.parse(reading_params.to_json))
          end
        end
      end

      context 'failed to create' do
        let!(:returned_params) { reading_params.clone }
        before :each do
          reading_params.delete("id")
          returned_params["errors"] = "Error"
          KalibroConfiguration.expects(:request).with("reading_groups/#{reading.group_id}/readings", {reading: reading_params}).returns({"reading" => returned_params})
        end

        context 'json format' do
          before :each do
            post :save, reading: reading_params, format: :json
          end

          it { is_expected.to respond_with(:unprocessable_entity) }

          it 'returns reading' do
            expect(JSON.parse(response.body)).to eq(JSON.parse(returned_params.to_json))
          end
        end
      end

      describe 'update' do
        let(:reading) { FactoryGirl.build(:reading) }
        let(:reading_params) { Hash[FactoryGirl.attributes_for(:reading).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with symbols and integers }

        context 'when updating an existing reading' do
          before :each do
            reading_without_id = reading_params.clone
            reading_without_id["reading_group_id"] = reading_without_id.delete("group_id")
            KalibroConfiguration.expects(:request).with("reading_groups/#{reading.group_id}/readings/#{reading.id}", {reading: reading_without_id}, :put).returns({"reading" => reading_without_id})
          end

          context 'successfully updated' do
            context 'json format' do
              before :each do
                put :save, reading: reading_params, format: :json
              end

              it { is_expected.to respond_with(:success) }

              it 'returns the reading' do
                reading.kalibro_errors = nil
                expect(JSON.parse(response.body)).to eq(JSON.parse(reading.to_json))
              end
            end
          end

          context 'when it fails to update' do
            pending
          end
        end
      end
    end
  end

  describe 'get' do
    let(:reading_params) { Hash[FactoryGirl.attributes_for(:reading).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with symbols and integers }
    let(:reading) { FactoryGirl.build(:reading) }

    context 'with and existent reading' do
      before :each do
        reading_params["reading_group_id"] = reading_params.delete("group_id")
        KalibroConfiguration.expects(:request).with("reading_groups/0/readings/#{reading.id}", {}, :get).returns("reading" => reading_params)
      end

      context 'json format' do
        before :each do
          post :get, id: reading.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns reading' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(reading_params.to_json))
        end
      end
    end

    context 'with and inexistent reading' do
      let!(:inexistent_reading_id) { reading.id + 1 }
      before :each do
        KalibroConfiguration.expects(:request).with("reading_groups/0/readings/#{inexistent_reading_id}", {}, :get).returns({"error" => "RecordNotFound"})
      end

      context 'json format' do
        before :each do
          post :get, id: inexistent_reading_id, format: :json
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
        KalibroConfiguration.expects(:request).with("reading_groups/0/readings/#{reading.id}", {}, :delete).returns({})
      end

      context 'json format' do
        before :each do
          post :destroy, id: reading.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns reading' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({}.to_json))
        end
      end
    end
  end

  describe 'of' do
    let!(:reading_group) {FactoryGirl.build(:reading_group)}
    let(:readings) { [ Hash[FactoryGirl.attributes_for(:reading).map { |k,v| [k.to_s, v.to_s] }] ] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with symbols and integers }

    before :each do
      KalibroConfiguration.expects(:request).with("reading_groups/#{reading_group.id}/readings", {}, :get).returns("readings" => readings)
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
