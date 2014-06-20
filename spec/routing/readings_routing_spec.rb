require "spec_helper"

describe ReadingsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:post, 'readings/save').
                  to(controller: :readings, action: :save) }
    it { is_expected.to route(:post, 'readings/get').
                  to(controller: :readings, action: :get) }
    it { is_expected.to route(:post, 'readings/destroy').
                  to(controller: :readings, action: :destroy) }
    it { is_expected.to route(:post, 'readings/of').
                  to(controller: :readings, action: :of) }
  end
end