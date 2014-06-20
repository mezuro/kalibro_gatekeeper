require 'spec_helper'

describe RepositoriesController, :type => :controller do
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

        it { is_expected.to respond_with(:success) }

        it 'returns the repository' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(repository.to_hash.to_json))
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

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns repository' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(repository.to_hash.to_json))
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
          repository.expects(:destroy).returns(true)
          post :destroy, id: repository.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns repository' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(repository.to_hash.to_json))
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

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns repository' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({error: 'RecordNotFound'}.to_json))
        end
      end
    end
  end

  describe 'of' do
    let!(:project) {FactoryGirl.build(:project)}
    let!(:repositories) { [FactoryGirl.build(:repository)] }

    before :each do
      KalibroGem::Entities::Repository.expects(:repositories_of).returns(repositories)
    end

    context 'json format' do
      before :each do
        get :of, project_id: project.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns the list of names' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({repositories: repositories.map { |c| c.to_hash }}.to_json))
      end
    end
  end

  describe 'process' do
    let(:repository) { FactoryGirl.build(:repository) }


    context 'with and existent repository' do
      before :each do
        KalibroGem::Entities::Repository.expects(:find).with(repository.id).returns(repository)
      end

      context 'json format' do
        before :each do
          repository.expects(:process).returns(true)
          post :process_repository, id: repository.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns confirmation' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({processing: repository.id}.to_json))
        end
      end
    end
  end

  describe 'cancel_process' do
    let(:repository) { FactoryGirl.build(:repository) }

    context 'with and existent repository' do
      before :each do
        KalibroGem::Entities::Repository.expects(:find).with(repository.id).returns(repository)
      end

      context 'json format' do
        before :each do
          repository.expects(:cancel_process).returns(true)
          post :cancel_process, id: repository.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns confirmation' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({canceled_processing_for: repository.id}.to_json))
        end
      end
    end
  end

  describe 'supported_types' do
    before :each do
      KalibroGem::Entities::Repository.expects(:repository_types).returns(['GIT'])

      get :supported_types, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns confirmation' do
      expect(JSON.parse(response.body)).to eq(JSON.parse({supported_types: ["GIT"]}.to_json))
    end
  end
end
