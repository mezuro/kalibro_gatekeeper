require "spec_helper"

describe ModuleResultsController do
  describe "routing" do
    it { should route(:post, 'module_results/get').
                  to(controller: :module_results, action: :get) }
    it { should route(:post, 'module_results/children_of').
                  to(controller: :module_results, action: :children_of) }
    it { should route(:post, 'module_results/history_of').
                  to(controller: :module_results, action: :history_of) }
  end
end