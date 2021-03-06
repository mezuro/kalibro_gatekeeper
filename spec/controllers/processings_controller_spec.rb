require 'rails_helper'

describe ProcessingsController, :type => :controller do
  describe 'has' do
    let!(:repository) { FactoryGirl.build(:repository) }

    before :each do
      KalibroProcessor.expects(:request).with("repositories/#{repository.id}/has_processing", {}, :get).returns({"has_processing" => true})
    end

    context 'json format' do
      before :each do
        post :has, repository_id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of date_metric_results' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({exists: true}.to_json))
      end
    end
  end

  describe 'has_ready' do
    let!(:repository) { FactoryGirl.build(:repository) }

    before :each do
      KalibroProcessor.expects(:request).with("repositories/#{repository.id}/has_ready_processing", {}, :get).returns({"has_ready_processing" => true})
    end

    context 'json format' do
      before :each do
        post :has_ready, repository_id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of date_metric_results' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({exists: true}.to_json))
      end
    end
  end

  describe 'has_after' do
    let!(:date) {"21/12/1995"} # Ruby's first publication
    let!(:repository) { FactoryGirl.build(:repository) }

    before :each do
      KalibroProcessor.expects(:request).with("repositories/#{repository.id}/has_processing/after", {'date' => date}).returns({"has_processing_in_time" => true})
    end

    context 'json format' do
      before :each do
        post :has_after, repository_id: repository.id, date: date, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of date_metric_results' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({exists: true}.to_json))
      end
    end
  end

  describe 'has_before' do
    let!(:date) {"21/12/1995"} # Ruby's first publication
    let!(:repository) { FactoryGirl.build(:repository) }

    before :each do
      KalibroProcessor.expects(:request).with("repositories/#{repository.id}/has_processing/before", {'date' => date}).returns({"has_processing_in_time" => true})
    end

    context 'json format' do
      before :each do
        post :has_before, repository_id: repository.id, date: date, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of date_metric_results' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({exists: true}.to_json))
      end
    end
  end

  describe 'last_state_of' do
    let!(:repository) { FactoryGirl.build(:repository) }

    before :each do
      KalibroProcessor.expects(:request).with("repositories/#{repository.id}/last_processing_state", {}, :get).returns({"processing_state" => "READY"})
    end

    context 'json format' do
      before :each do
        post :last_state_of, repository_id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of date_metric_results' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({state: "READY"}.to_json))
      end
    end
  end

  describe 'last_ready_of' do
    let!(:processing_hash) { Hash[FactoryGirl.attributes_for(:processing, id: 0).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with sybols and integers
    let!(:process_time_hash) { Hash[FactoryGirl.attributes_for(:process_time).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with sybols and integers
    let!(:repository) { FactoryGirl.build(:repository) }
    let!(:processing) { FactoryGirl.build(:processing, id: 0) }

    before :each do
      KalibroProcessor.expects(:request).with("repositories/#{repository.id}/last_ready_processing", {}, :get).returns({"last_ready_processing" => processing_hash})
      KalibroProcessor.expects(:request).with("processings/#{processing.id}/process_times", {}, :get).returns({"process_times" => [process_time_hash]})
    end

    context 'json format' do
      before :each do
        post :last_ready_of, repository_id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the last ready processing of the repository' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({"processing" => processing_hash}.to_json))
      end
    end
  end

  describe 'last_of' do
    let!(:processing_hash) { Hash[FactoryGirl.attributes_for(:processing, id: 0).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with sybols and integers
    let!(:process_time_hash) { Hash[FactoryGirl.attributes_for(:process_time).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with sybols and integers
    let!(:repository) { FactoryGirl.build(:repository) }
    let!(:processing) { FactoryGirl.build(:processing, id: 0) }

    before :each do
      KalibroProcessor.expects(:request).with("repositories/#{repository.id}/last_processing", {}).returns({"processing" => processing_hash})
      KalibroProcessor.expects(:request).with("processings/#{processing.id}/process_times", {}, :get).returns({"process_times" => [process_time_hash]})
    end

    context 'json format' do
      before :each do
        post :last_of, repository_id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of date_metric_results' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({"processing" => processing_hash}.to_json))
      end
    end
  end

  describe 'first_of' do
    let!(:processing_hash) { Hash[FactoryGirl.attributes_for(:processing, id: 0).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with sybols and integers
    let!(:process_time_hash) { Hash[FactoryGirl.attributes_for(:process_time).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with sybols and integers
    let!(:repository) { FactoryGirl.build(:repository) }
    let!(:processing) { FactoryGirl.build(:processing, id: 0) }

    before :each do
      KalibroProcessor.expects(:request).with("repositories/#{repository.id}/first_processing", {}).returns({"processing" => processing_hash})
      KalibroProcessor.expects(:request).with("processings/#{processing.id}/process_times", {}, :get).returns({"process_times" => [process_time_hash]})
    end

    context 'json format' do
      before :each do
        post :first_of, repository_id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of date_metric_results' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({"processing" => processing_hash}.to_json))
      end
    end
  end

  describe 'first_after_of' do
    let!(:processing_hash) { Hash[FactoryGirl.attributes_for(:processing, id: 0).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with sybols and integers
    let!(:process_time_hash) { Hash[FactoryGirl.attributes_for(:process_time).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with sybols and integers
    let!(:repository) { FactoryGirl.build(:repository) }
    let!(:processing) { FactoryGirl.build(:processing, id: 0) }
    let!(:date) {"21/12/1995"} # Ruby's first publication

    before :each do
      KalibroProcessor.expects(:request).with("repositories/#{repository.id}/first_processing/after", {"date" => date}).returns({"processing" => processing_hash})
      KalibroProcessor.expects(:request).with("processings/#{processing.id}/process_times", {}, :get).returns({"process_times" => [process_time_hash]})
    end

    context 'json format' do
      before :each do
        post :first_after_of, repository_id: repository.id, date: date, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of date_metric_results' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({"processing" => processing_hash}.to_json))
      end
    end
  end

  describe 'last_before_of' do
    let!(:processing_hash) { Hash[FactoryGirl.attributes_for(:processing, id: 0).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with sybols and integers
    let!(:process_time_hash) { Hash[FactoryGirl.attributes_for(:process_time).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with sybols and integers
    let!(:repository) { FactoryGirl.build(:repository) }
    let!(:processing) { FactoryGirl.build(:processing, id: 0) }
    let!(:date) {"21/12/1995"} # Ruby's first publication

    before :each do
      KalibroProcessor.expects(:request).with("repositories/#{repository.id}/last_processing/before", {"date" => date}).returns({"processing" => processing_hash})
      KalibroProcessor.expects(:request).with("processings/#{processing.id}/process_times", {}, :get).returns({"process_times" => [process_time_hash]})
    end

    context 'json format' do
      before :each do
        post :last_before_of, repository_id: repository.id, date: date, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of date_metric_results' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({"processing" => processing_hash}.to_json))
      end
    end
  end
end
