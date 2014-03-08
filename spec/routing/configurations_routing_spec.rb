require "spec_helper"

describe ConfigurationsController do
  describe "routing" do
    it { should route(:post, 'configurations/exists').
                  to(controller: :configurations, action: :exists) }
    it { should route(:get, 'configurations/all').
                  to(controller: :configurations, action: :all) }
    it { should route(:post, 'configurations/save').
                  to(controller: :configurations, action: :save) }
    it { should route(:post, 'configurations/get').
                  to(controller: :configurations, action: :get) }
    it { should route(:post, 'configurations/destroy').
                  to(controller: :configurations, action: :destroy) }
  end
end