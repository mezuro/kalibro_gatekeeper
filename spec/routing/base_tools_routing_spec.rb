require "spec_helper"

describe BaseToolsController do
  describe "routing" do
    it { should route(:get, 'base_tools/all_names').
                  to(controller: :base_tools, action: :all_names) }
    it { should route(:post, 'base_tools/get').
                  to(controller: :base_tools, action: :get) }
  end
end