require "spec_helper"

describe ReadingGroupsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:post, 'reading_groups/exists').
                  to(controller: :reading_groups, action: :exists) }
    it { is_expected.to route(:get, 'reading_groups/all').
                  to(controller: :reading_groups, action: :all) }
    it { is_expected.to route(:post, 'reading_groups/save').
                  to(controller: :reading_groups, action: :save) }
    it { is_expected.to route(:post, 'reading_groups/get').
                  to(controller: :reading_groups, action: :get) }
    it { is_expected.to route(:post, 'reading_groups/destroy').
                  to(controller: :reading_groups, action: :destroy) }
  end
end