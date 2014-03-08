require "spec_helper"

describe ModuleResultsController do
  describe "routing" do
    it { should route(:post, 'module_results/get').
                  to(controller: :module_results, action: :get) }
  end
end