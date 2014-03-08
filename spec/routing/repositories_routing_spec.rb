require "spec_helper"

describe RepositoriesController do
  describe "routing" do
    it { should route(:post, 'repositories/save').
                  to(controller: :repositories, action: :save) }
    it { should route(:post, 'repositories/destroy').
                  to(controller: :repositories, action: :destroy) }
    it { should route(:post, 'repositories/of').
                  to(controller: :repositories, action: :of) }
  end
end