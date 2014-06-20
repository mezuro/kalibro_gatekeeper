require "rails_helper"

describe BaseToolsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, 'base_tools/all_names').
                  to(controller: :base_tools, action: :all_names) }
    it { is_expected.to route(:post, 'base_tools/get').
                  to(controller: :base_tools, action: :get) }
  end
end