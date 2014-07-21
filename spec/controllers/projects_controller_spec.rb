require 'rails_helper'

describe ProjectsController, :type => :controller do
  describe 'exists' do
    before :each do
      KalibroProcessor.expects(:request).with("projects/42/exists", {}, :get).returns({exists: true})
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
    let!(:projects) { [FactoryGirl.build(:project), FactoryGirl.build(:another_project)] }

    before :each do
      KalibroProcessor.expects(:request).with("projects", {}, :get).returns({projects: projects.map { |c| c.to_hash }})
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
        expect(JSON.parse(response.body)).to eq(JSON.parse({projects: projects.map { |c| c.to_hash }}.to_json))
      end
    end
  end

  #TODO: refactor this spec
  describe 'save' do
    let(:params) { {'project' => Hash[FactoryGirl.attributes_for(:project, id: 0).map { |k,v| [k.to_s, v.to_s] }] } } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with sybols and integers

    context 'when creating a project' do
      let(:project) { FactoryGirl.build(:project, id: nil) }

      context 'successfully saved' do
        before :each do
          KalibroProcessor.expects(:request).with("projects", params).returns(params)
        end

        context 'json format' do
          before :each do
            call_params = params.clone
            call_params[:format] = :json
            post :save, call_params
          end

          it { is_expected.to respond_with(:success) }

          it 'returns the project' do
            expect(JSON.parse(response.body)).to eq(JSON.parse(params['project'].to_json))
          end
        end
      end

      context 'failed to save' do
        let!(:return_params) {params.clone}

        before :each do
          return_params['project']["errors"] = ["Error"]
          KalibroProcessor.expects(:request).with("projects", params).returns(return_params)
        end

        context 'json format' do
          before :each do
            call_params = params.clone
            call_params[:format] = :json
            post :save, call_params
          end

          it { is_expected.to respond_with(:unprocessable_entity) }

          it 'returns project' do
            expect(JSON.parse(response.body)).to eq(JSON.parse(return_params['project'].to_json))
          end
        end
      end
    end

    context 'when updating a project' do
      let! (:params_update) {params.clone}

      before :each do
        params_update['project']['id'] = '1'
        KalibroProcessor.expects(:request).with("projects/#{params_update['project']['id']}/exists", {}, :get).returns({'exists' => :true})
      end

      context 'with valid params' do
        before :each do
          KalibroProcessor.expects(:request).with("projects/#{params_update['project']['id']}", params_update, :put).returns(params_update)
        end

        context 'json format' do
          before :each do
            post :save, 'project' => params_update['project'], format: :json
          end

          it { is_expected.to respond_with(:success) }
        end
      end
    end
  end

  describe 'get' do
    let(:project) { FactoryGirl.build(:project) }


    context 'with and existent project' do
      before :each do
        KalibroProcessor.expects(:request).with("projects/#{project.id}", {}, :get).returns({'project' => project.to_hash})
      end

      context 'json format' do
        before :each do
          post :get, id: project.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns project' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(project.to_hash.to_json))
        end
      end
    end

    context 'with and inexistent project' do
      before :each do
        KalibroProcessor.expects(:request).with("projects/#{project.id}", {}, :get).returns({'error' => 'RecordNotFound'})
      end

      context 'json format' do
        before :each do
          post :get, id: project.id, format: :json
        end

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns project' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({error: 'RecordNotFound'}.to_json))
        end
      end
    end
  end

  describe 'destroy' do
    let(:project) { FactoryGirl.build(:project) }


    context 'with and existent project' do
      before :each do
        KalibroProcessor.expects(:request).with("projects/#{project.id}", {}, :delete).returns({})
      end

      context 'json format' do
        before :each do
          post :destroy, id: project.id, format: :json
        end

        it { is_expected.to respond_with(:success) }
      end
    end
  end
end
