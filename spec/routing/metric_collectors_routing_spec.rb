require "rails_helper"

describe MetricCollectorsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, 'metric_collectors/all_names').
                  to(controller: :metric_collectors, action: :all_names) }
    it { is_expected.to route(:post, 'metric_collectors/get').
                  to(controller: :metric_collectors, action: :get) }
  end
end