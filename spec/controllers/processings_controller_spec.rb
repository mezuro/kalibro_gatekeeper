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
end
