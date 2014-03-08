require "spec_helper"

describe ProcessingsController do
  describe "routing" do
    it { should route(:post, 'processings/has').
                  to(controller: :processings, action: :has) }
  end
end