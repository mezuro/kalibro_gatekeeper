require "rails_helper"

describe RangesController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:post, 'ranges/save').
                  to(controller: :ranges, action: :save) }
    it { is_expected.to route(:post, 'ranges/destroy').
                  to(controller: :ranges, action: :destroy) }
    it { is_expected.to route(:post, 'ranges/of').
                  to(controller: :ranges, action: :of) }
  end
end