require "rails_helper"

describe MetricConfigurationsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:post, 'metric_configurations/save').
                  to(controller: :metric_configurations, action: :save) }
    it { is_expected.to route(:post, 'metric_configurations/get').
                  to(controller: :metric_configurations, action: :get) }
    it { is_expected.to route(:post, 'metric_configurations/destroy').
                  to(controller: :metric_configurations, action: :destroy) }
    it { is_expected.to route(:post, 'metric_configurations/of').
                  to(controller: :metric_configurations, action: :of) }
  end
end