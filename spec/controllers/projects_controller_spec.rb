require 'rails_helper'

describe ProjectsController, :type => :controller do
  describe 'exists' do
    before :each do
      KalibroGem::Entities::Project.expects(:exists?).with(42).returns(true)
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
      KalibroGem::Entities::Project.expects(:all).returns(projects)
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

  describe 'save' do
    let(:project) { FactoryGirl.build(:project, id: nil) }

    context 'successfully saved' do
      before :each do
        KalibroGem::Entities::Project.any_instance.expects(:save).returns(true)
      end

      context 'json format' do
        before :each do
          post :save, project: project.to_hash, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns the project' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(project.to_hash.to_json))
        end
      end
    end

    context 'failed to save' do
      before :each do
        KalibroGem::Entities::Project.any_instance.expects(:save).returns(false)
      end

      context 'json format' do
        before :each do
          post :save, project: project.to_hash, format: :json
        end

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns project' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(project.to_hash.to_json))
        end
      end
    end
  end

  describe 'get' do
    let(:project) { FactoryGirl.build(:project) }


    context 'with and existent project' do
      before :each do
        KalibroGem::Entities::Project.expects(:find).with(project.id).returns(project)
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
        KalibroGem::Entities::Project.expects(:find).with(project.id).raises(KalibroGem::Errors::RecordNotFound)
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
        KalibroGem::Entities::Project.expects(:find).with(project.id).returns(project)
      end

      context 'json format' do
        before :each do
          project.expects(:destroy).returns(true)
          post :destroy, id: project.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns project' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(project.to_hash.to_json))
        end
      end
    end

    context 'with and inexistent project' do
      before :each do
        KalibroGem::Entities::Project.expects(:find).with(project.id).raises(KalibroGem::Errors::RecordNotFound)
      end

      context 'json format' do
        before :each do
          post :destroy, id: project.id, format: :json
        end

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'returns project' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({error: 'RecordNotFound'}.to_json))
        end
      end
    end
  end
end
