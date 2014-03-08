require "spec_helper"

describe RepositoriesController do
  describe "routing" do
    it { should route(:post, 'repositories/save').
                  to(controller: :repositories, action: :save) }
    it { should route(:post, 'repositories/destroy').
                  to(controller: :repositories, action: :destroy) }
    it { should route(:post, 'repositories/of').
                  to(controller: :repositories, action: :of) }
    it { should route(:get, 'repositories/process').
                  to(controller: :repositories, action: :process_repository) }
    it { should route(:get, 'repositories/cancel_process').
                  to(controller: :repositories, action: :cancel_process) }
  end
end