require "spec_helper"

describe MetricResultsController do
  describe "routing" do
    it { should route(:post, 'metric_results/history_of_metric').
                  to(controller: :metric_results, action: :history_of_metric) }
  end
end