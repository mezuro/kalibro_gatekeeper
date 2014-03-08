require "spec_helper"

describe BaseToolsController do
  describe "routing" do
    it { should route(:get, 'base_tools/all_names').
                  to(controller: :base_tools, action: :all_names) }
  end
end