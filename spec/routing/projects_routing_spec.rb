require "spec_helper"

describe ProjectsController do
  describe "routing" do
    it { should route(:post, 'projects/exists').
                  to(controller: :projects, action: :exists) }
    it { should route(:get, 'projects/all').
                  to(controller: :projects, action: :all) }
    it { should route(:post, 'projects/save').
                  to(controller: :projects, action: :save) }
    it { should route(:post, 'projects/get').
                  to(controller: :projects, action: :get) }
    it { should route(:post, 'projects/destroy').
                  to(controller: :projects, action: :destroy) }
  end
end