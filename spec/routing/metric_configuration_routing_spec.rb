require "spec_helper"

describe MetricConfigurationsController do
  describe "routing" do
    it { should route(:post, 'metric_configurations/save').
                  to(controller: :metric_configurations, action: :save) }
    it { should route(:post, 'metric_configurations/get').
                  to(controller: :metric_configurations, action: :get) }
    it { should route(:post, 'metric_configurations/destroy').
                  to(controller: :metric_configurations, action: :destroy) }
  end
end