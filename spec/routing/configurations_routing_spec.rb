require "spec_helper"

describe ConfigurationsController do
  describe "routing" do
    it { should route(:post, 'configurations/exists').
                  to(controller: :configurations, action: :exists) }
    it { should route(:get, 'configurations/all').
                  to(controller: :configurations, action: :all) }
    it { should route(:post, 'configurations/save').
                  to(controller: :configurations, action: :save) }
  end
end