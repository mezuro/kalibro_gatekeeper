require "spec_helper"

describe ReadingGroupsController do
  describe "routing" do
    it { should route(:post, 'reading_groups/exists').
                  to(controller: :reading_groups, action: :exists) }
    it { should route(:get, 'reading_groups/all').
                  to(controller: :reading_groups, action: :all) }
    it { should route(:post, 'reading_groups/save').
                  to(controller: :reading_groups, action: :save) }
    it { should route(:post, 'reading_groups/get').
                  to(controller: :reading_groups, action: :get) }
    it { should route(:post, 'reading_groups/destroy').
                  to(controller: :reading_groups, action: :destroy) }
  end
end