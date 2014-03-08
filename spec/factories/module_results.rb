# This file is part of KalibroGem
# Copyright (C) 2013  it's respectives authors (please see the AUTHORS file)
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

FactoryGirl.define do
  factory :module_result, class: KalibroGem::Entities::ModuleResult do
    id  "42"
    self.module { FactoryGirl.build(:module) }
    grade "10.0"
    parent_id "21"
    height "6"
  end

   factory :root_module_result, class: KalibroGem::Entities::ModuleResult do
    id  "21"
    self.module { FactoryGirl.build(:module) }
    grade "6.0"
    parent_id nil
    height "1"
  end
end