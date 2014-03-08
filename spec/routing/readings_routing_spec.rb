require "spec_helper"

describe ReadingsController do
  describe "routing" do
    it { should route(:post, 'readings/save').
                  to(controller: :readings, action: :save) }
    it { should route(:post, 'readings/get').
                  to(controller: :readings, action: :get) }
    it { should route(:post, 'readings/destroy').
                  to(controller: :readings, action: :destroy) }
    it { should route(:post, 'readings/of').
                  to(controller: :readings, action: :of) }
  end
end