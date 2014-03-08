require "spec_helper"

describe InformationController do
  describe "routing" do
    it { should route(:get, '/').
                  to(controller: :information, action: :data) }
  end
end