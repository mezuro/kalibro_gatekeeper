require 'spec_helper'

describe RepositoriesController do
  describe 'save' do
    let(:repository) { FactoryGirl.build(:repository, id: nil) }

    context 'successfully saved' do
      before :each do
        KalibroGem::Entities::Repository.any_instance.expects(:save).returns(true)
      end

      context 'json format' do
        before :each do
          post :save, repository: repository.to_hash, format: :json
        end

        it { should respond_with(:success) }

        it 'returns the repository' do
          JSON.parse(response.body).should eq(JSON.parse(repository.to_hash.to_json))
        end
      end
    end

    context 'failed to save' do
      before :each do
        KalibroGem::Entities::Repository.any_instance.expects(:save).returns(false)
      end

      context 'json format' do
        before :each do
          post :save, repository: repository.to_hash, format: :json
        end

        it { should respond_with(:unprocessable_entity) }

        it 'returns repository' do
          JSON.parse(response.body).should eq(JSON.parse(repository.to_hash.to_json))
        end
      end
    end
  end

  describe 'destroy' do
    let(:repository) { FactoryGirl.build(:repository) }


    context 'with and existent repository' do
      before :each do
        KalibroGem::Entities::Repository.expects(:find).with(repository.id).returns(repository)
      end

      context 'json format' do
        before :each do
          repository.expects(:detroy).returns(true)
          post :destroy, id: repository.id, format: :json
        end

        it { should respond_with(:success) }

        it 'returns repository' do
          JSON.parse(response.body).should eq(JSON.parse(repository.to_hash.to_json))
        end
      end
    end

    context 'with and inexistent repository' do
      before :each do
        KalibroGem::Entities::Repository.expects(:find).with(repository.id).raises(KalibroGem::Errors::RecordNotFound)
      end

      context 'json format' do
        before :each do
          post :destroy, id: repository.id, format: :json
        end

        it { should respond_with(:unprocessable_entity) }

        it 'returns repository' do
          JSON.parse(response.body).should eq(JSON.parse({error: 'RecordNotFound'}.to_json))
        end
      end
    end
  end
end
