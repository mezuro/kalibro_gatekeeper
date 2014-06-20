require "rails_helper"

describe RepositoriesController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:post, 'repositories/save').
                  to(controller: :repositories, action: :save) }
    it { is_expected.to route(:post, 'repositories/destroy').
                  to(controller: :repositories, action: :destroy) }
    it { is_expected.to route(:post, 'repositories/of').
                  to(controller: :repositories, action: :of) }
    it { is_expected.to route(:post, 'repositories/process').
                  to(controller: :repositories, action: :process_repository) }
    it { is_expected.to route(:post, 'repositories/cancel_process').
                  to(controller: :repositories, action: :cancel_process) }
    it { is_expected.to route(:get, 'repositories/supported_types').
                  to(controller: :repositories, action: :supported_types) }
  end
end