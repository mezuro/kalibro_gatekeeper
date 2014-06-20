require "spec_helper"

describe ProcessingsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:post, 'processings/has').
                  to(controller: :processings, action: :has) }
    it { is_expected.to route(:post, 'processings/has_ready').
                  to(controller: :processings, action: :has_ready) }
    it { is_expected.to route(:post, 'processings/has_after').
                  to(controller: :processings, action: :has_after) }
    it { is_expected.to route(:post, 'processings/has_before').
                  to(controller: :processings, action: :has_before) }
    it { is_expected.to route(:post, 'processings/last_state_of').
                  to(controller: :processings, action: :last_state_of) }
    it { is_expected.to route(:post, 'processings/last_ready_of').
                  to(controller: :processings, action: :last_ready_of) }
    it { is_expected.to route(:post, 'processings/last_of').
                  to(controller: :processings, action: :last_of) }
    it { is_expected.to route(:post, 'processings/first_of').
                  to(controller: :processings, action: :first_of) }
    it { is_expected.to route(:post, 'processings/first_after_of').
                  to(controller: :processings, action: :first_after_of) }
    it { is_expected.to route(:post, 'processings/last_before_of').
                  to(controller: :processings, action: :last_before_of) }
  end
end