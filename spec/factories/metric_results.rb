# This file is part of KalibroGatekeeper
# Copyright (C) 2014  it's respectives authors (please see the AUTHORS file)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class MetricResult < KalibroGem::Entities::Model
  attr_accessor :id, :value, :metric, :metric_configuration_id
end

FactoryGirl.define do
  factory :metric_result, class: MetricResult do
    id  "42"
    value "10.0"
    metric { FactoryGirl.build(:metric) }
    metric_configuration_id 13
  end
end
