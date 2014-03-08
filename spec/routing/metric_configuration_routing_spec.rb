require "spec_helper"

describe MetricConfigurationsController do
  describe "routing" do
    it { should route(:post, 'metric_configurations/save').
                  to(controller: :metric_configurations, action: :save) }
    it { should route(:post, 'metric_configurations/get').
                  to(controller: :metric_configurations, action: :get) }
    it { should route(:post, 'metric_configurations/destroy').
                  to(controller: :metric_configurations, action: :destroy) }
    it { should route(:post, 'metric_configurations/of').
                  to(controller: :metric_configurations, action: :of) }
  end
end