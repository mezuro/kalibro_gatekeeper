require 'spec_helper'

describe Information do
  describe 'data' do
    it 'returns a hash with version, license and repository url' do
      Information.data.should eq({version: Information::VERSION, license: Information::LICENSE, repository_url: Information::REPOSITORY_URL})
    end
  end
end
