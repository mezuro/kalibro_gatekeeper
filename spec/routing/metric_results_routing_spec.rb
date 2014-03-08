require "spec_helper"

describe MetricResultsController do
  describe "routing" do
    it { should route(:post, 'metric_results/history_of_metric').
                  to(controller: :metric_results, action: :history_of_metric) }
    it { should route(:post, 'metric_results/descendant_results_of').
                  to(controller: :metric_results, action: :descendant_results_of) }
    it { should route(:post, 'metric_results/of').
                  to(controller: :metric_results, action: :of) }
  end
end