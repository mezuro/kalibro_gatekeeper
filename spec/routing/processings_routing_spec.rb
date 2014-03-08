require "spec_helper"

describe ProcessingsController do
  describe "routing" do
    it { should route(:post, 'processings/has').
                  to(controller: :processings, action: :has) }
    it { should route(:post, 'processings/has_ready').
                  to(controller: :processings, action: :has_ready) }
    it { should route(:post, 'processings/has_after').
                  to(controller: :processings, action: :has_after) }
    it { should route(:post, 'processings/has_before').
                  to(controller: :processings, action: :has_before) }
    it { should route(:post, 'processings/last_state_of').
                  to(controller: :processings, action: :last_state_of) }
    it { should route(:post, 'processings/last_ready_of').
                  to(controller: :processings, action: :last_ready_of) }
    it { should route(:post, 'processings/last_of').
                  to(controller: :processings, action: :last_of) }
    it { should route(:post, 'processings/first_of').
                  to(controller: :processings, action: :first_of) }
  end
end