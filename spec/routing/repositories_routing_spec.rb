require "spec_helper"

describe ConfigurationsController do
  describe "routing" do
    it { should route(:post, 'configurations/save').
                  to(controller: :configurations, action: :save) }
    it { should route(:post, 'configurations/destroy').
                  to(controller: :configurations, action: :destroy) }
  end
end