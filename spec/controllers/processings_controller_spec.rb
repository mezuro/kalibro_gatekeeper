require 'spec_helper'

describe ProcessingsController do
  describe 'has' do
    let!(:repository) { FactoryGirl.build(:repository) }

    before :each do
      KalibroGem::Entities::Processing.expects(:has_processing).with(repository.id).returns(true)
    end

    context 'json format' do
      before :each do
        post :has, repository_id: repository.id, format: :json
      end

      it { should respond_with(:success) }

      it 'returns the list of date_metric_results' do
        JSON.parse(response.body).should eq(JSON.parse({exists: true}.to_json))
      end
    end
  end

  describe 'has_ready' do
    let!(:repository) { FactoryGirl.build(:repository) }

    before :each do
      KalibroGem::Entities::Processing.expects(:has_ready_processing).with(repository.id).returns(true)
    end

    context 'json format' do
      before :each do
        post :has_ready, repository_id: repository.id, format: :json
      end

      it { should respond_with(:success) }

      it 'returns the list of date_metric_results' do
        JSON.parse(response.body).should eq(JSON.parse({exists: true}.to_json))
      end
    end
  end

  describe 'has_after' do
    let!(:date) {"21/12/1995"} # Ruby's first publication
    let!(:repository) { FactoryGirl.build(:repository) }

    before :each do
      KalibroGem::Entities::Processing.expects(:has_processing_after).with(repository.id, date).returns(true)
    end

    context 'json format' do
      before :each do
        post :has_after, repository_id: repository.id, date: date, format: :json
      end

      it { should respond_with(:success) }

      it 'returns the list of date_metric_results' do
        JSON.parse(response.body).should eq(JSON.parse({exists: true}.to_json))
      end
    end
  end

  describe 'has_before' do
    let!(:date) {"21/12/1995"} # Ruby's first publication
    let!(:repository) { FactoryGirl.build(:repository) }

    before :each do
      KalibroGem::Entities::Processing.expects(:has_processing_before).with(repository.id, date).returns(true)
    end

    context 'json format' do
      before :each do
        post :has_before, repository_id: repository.id, date: date, format: :json
      end

      it { should respond_with(:success) }

      it 'returns the list of date_metric_results' do
        JSON.parse(response.body).should eq(JSON.parse({exists: true}.to_json))
      end
    end
  end

  describe 'last_state_of' do
    let!(:repository) { FactoryGirl.build(:repository) }

    before :each do
      KalibroGem::Entities::Processing.expects(:last_processing_state_of).with(repository.id).returns("READY")
    end

    context 'json format' do
      before :each do
        post :last_state_of, repository_id: repository.id, format: :json
      end

      it { should respond_with(:success) }

      it 'returns the list of date_metric_results' do
        JSON.parse(response.body).should eq(JSON.parse({state: "READY"}.to_json))
      end
    end
  end

  describe 'last_ready_of' do
    let!(:processing) { FactoryGirl.build(:processing) }
    let!(:repository) { FactoryGirl.build(:repository) }

    before :each do
      KalibroGem::Entities::Processing.expects(:last_ready_processing_of).with(repository.id).returns(processing)
    end

    context 'json format' do
      before :each do
        post :last_ready_of, repository_id: repository.id, format: :json
      end

      it { should respond_with(:success) }

      it 'returns the list of date_metric_results' do
        JSON.parse(response.body).should eq(JSON.parse({processing: processing.to_hash}.to_json))
      end
    end
  end

  describe 'last_of' do
    let!(:processing) { FactoryGirl.build(:processing) }
    let!(:repository) { FactoryGirl.build(:repository) }

    before :each do
      KalibroGem::Entities::Processing.expects(:last_processing_of).with(repository.id).returns(processing)
    end

    context 'json format' do
      before :each do
        post :last_of, repository_id: repository.id, format: :json
      end

      it { should respond_with(:success) }

      it 'returns the list of date_metric_results' do
        JSON.parse(response.body).should eq(JSON.parse({processing: processing.to_hash}.to_json))
      end
    end
  end

  describe 'first_of' do
    let!(:processing) { FactoryGirl.build(:processing) }
    let!(:repository) { FactoryGirl.build(:repository) }

    before :each do
      KalibroGem::Entities::Processing.expects(:first_processing_of).with(repository.id).returns(processing)
    end

    context 'json format' do
      before :each do
        post :first_of, repository_id: repository.id, format: :json
      end

      it { should respond_with(:success) }

      it 'returns the list of date_metric_results' do
        JSON.parse(response.body).should eq(JSON.parse({processing: processing.to_hash}.to_json))
      end
    end
  end
end
