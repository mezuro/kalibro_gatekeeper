require "spec_helper"

describe InformationController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, '/').
                  to(controller: :information, action: :data) }
  end
end