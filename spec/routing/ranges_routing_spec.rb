require "spec_helper"

describe RangesController do
  describe "routing" do
    it { should route(:post, 'ranges/save').
                  to(controller: :ranges, action: :save) }
    it { should route(:post, 'ranges/destroy').
                  to(controller: :ranges, action: :destroy) }
    it { should route(:post, 'ranges/of').
                  to(controller: :ranges, action: :of) }
  end
end