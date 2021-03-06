require "rails_helper"

describe ModuleResultsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:post, 'module_results/get').
                  to(controller: :module_results, action: :get) }
    it { is_expected.to route(:post, 'module_results/children_of').
                  to(controller: :module_results, action: :children_of) }
    it { is_expected.to route(:post, 'module_results/history_of').
                  to(controller: :module_results, action: :history_of) }
  end
end