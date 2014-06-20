require "rails_helper"

describe ProjectsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:post, 'projects/exists').
                  to(controller: :projects, action: :exists) }
    it { is_expected.to route(:get, 'projects/all').
                  to(controller: :projects, action: :all) }
    it { is_expected.to route(:post, 'projects/save').
                  to(controller: :projects, action: :save) }
    it { is_expected.to route(:post, 'projects/get').
                  to(controller: :projects, action: :get) }
    it { is_expected.to route(:post, 'projects/destroy').
                  to(controller: :projects, action: :destroy) }
  end
end