require "spec_helper"

describe ProcessingsController do
  describe "routing" do
    it { should route(:post, 'processings/has').
                  to(controller: :processings, action: :has) }
    it { should route(:post, 'processings/has_ready').
                  to(controller: :processings, action: :has_ready) }
    it { should route(:post, 'processings/has_after').
                  to(controller: :processings, action: :has_after) }
  end
end