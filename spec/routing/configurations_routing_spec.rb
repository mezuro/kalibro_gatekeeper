require "rails_helper"

describe ConfigurationsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:post, 'configurations/exists').
                  to(controller: :configurations, action: :exists) }
    it { is_expected.to route(:get, 'configurations/all').
                  to(controller: :configurations, action: :all) }
    it { is_expected.to route(:post, 'configurations/save').
                  to(controller: :configurations, action: :save) }
    it { is_expected.to route(:post, 'configurations/get').
                  to(controller: :configurations, action: :get) }
    it { is_expected.to route(:post, 'configurations/destroy').
                  to(controller: :configurations, action: :destroy) }
  end
end