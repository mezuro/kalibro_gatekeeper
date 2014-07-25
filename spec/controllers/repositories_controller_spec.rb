require 'rails_helper'

describe RepositoriesController, :type => :controller do
  describe 'save' do
    let(:params) { {'repository' => Hash[FactoryGirl.attributes_for(:repository, id: 0).map { |k,v| [k.to_s, v.to_s] }] } } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with sybols and integers
    let!(:repository) { FactoryGirl.build(:repository, id: nil) }

    context 'when creating a repository' do
      context 'successfully saved' do
        before :each do
          expectation = {'repository' => params['repository'].clone}
          expectation['repository']['scm_type'] = expectation['repository']['type']
          expectation['repository'].delete('type')
          expectation['repository']['period'] = expectation['repository']['process_period']
          expectation['repository'].delete('process_period')
          KalibroProcessor.expects(:request).with("repositories", expectation).returns(params)
        end

        context 'json format' do
          before :each do
            post :save, 'repository' => params['repository'], format: :json
          end

          it { is_expected.to respond_with(:success) }

          it 'returns the repository' do
            expect(JSON.parse(response.body)).to eq(JSON.parse(params['repository'].to_json))
          end
        end
      end

      context 'failed to save' do
        let!(:return_params) {params.clone}

        before :each do
          return_params['repository']["errors"] = ["Error"]
          expectation = {'repository' => params['repository'].clone}
          expectation['repository']['scm_type'] = expectation['repository']['type']
          expectation['repository'].delete('type')
          expectation['repository']['period'] = expectation['repository']['process_period']
          expectation['repository'].delete('process_period')
          KalibroProcessor.expects(:request).with("repositories", expectation).returns(return_params)
        end

        context 'json format' do
          before :each do
            post :save, 'repository' => params['repository'], format: :json
          end

          it { is_expected.to respond_with(:unprocessable_entity) }

          it 'returns repository' do
            expect(JSON.parse(response.body)).to eq(JSON.parse(return_params['repository'].to_json))
          end
        end
      end
    end

    context 'when updating a repository' do
      let!(:params_update) {params.clone}

      before :each do
        params_update['repository']['id'] = '1'
        KalibroProcessor.expects(:request).with("repositories/#{params_update['repository']['id']}", {}, :get).returns({'repository' => repository})
      end

      context 'with valid params' do
        before :each do
          expectation = {'repository' => params_update['repository'].clone}
          expectation['repository']['scm_type'] = expectation['repository']['type']
          expectation['repository'].delete('type')
          expectation['repository']['period'] = expectation['repository']['process_period']
          expectation['repository'].delete('process_period')
          KalibroProcessor.expects(:request).with("repositories/#{expectation['repository']['id']}", expectation, :put).returns(params_update)
        end

        context 'json format' do
          before :each do
            post :save, 'repository' => params_update['repository'], format: :json
          end

          it 'is expected to respond with success' do
            is_expected.to respond_with(:success)
          end
        end
      end
    end
  end

  describe 'destroy' do
    let(:repository) { FactoryGirl.build(:repository) }

    context 'with and existent repository' do
      before :each do
        KalibroProcessor.expects(:request).with("repositories/#{repository.id}", {}, :delete).returns({})
        post :destroy, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }
    end
  end

  describe 'of' do
    let!(:project) {FactoryGirl.build(:project)}
    let!(:repositories) { [FactoryGirl.build(:repository).to_hash] }

    before :each do
      KalibroProcessor.expects(:request).with("projects/#{project.id}/repositories_of", {}, :get).returns({"repositories" => repositories})
      get :of, project_id: project.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns the list of names' do
      expect(JSON.parse(response.body)).to eq(JSON.parse({repositories: repositories.map { |c| c.to_hash }}.to_json))
    end
  end

  describe 'process' do
    let(:repository) { FactoryGirl.build(:repository) }

    context 'with a correct execution' do
      before :each do
        KalibroProcessor.expects(:request).with("repositories/#{repository.id}/process", {}, :get).returns({})
        get :process_repository, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }
    end
  end

  describe 'cancel_process' do
    let(:repository) { FactoryGirl.build(:repository) }

    context 'json format' do
      before :each do
        post :cancel_process, id: repository.id, format: :json
      end

      it { is_expected.to respond_with(:success) }
    end
  end

  describe 'supported_types' do
    let!(:types) { {types: ["GIT"]} }
    before :each do
      KalibroProcessor.expects(:request).with("repositories/types", {}, :get).returns(types)

      get :supported_types, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns confirmation' do
      expect(JSON.parse(response.body)).to eq(JSON.parse(types.to_json))
    end
  end
end
