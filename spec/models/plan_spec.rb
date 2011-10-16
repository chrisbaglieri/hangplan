require 'spec_helper'

describe Plan do
  it { should belong_to(:owner) }
  it { should have_many(:participants) }
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:location) }
  it { should allow_mass_assignment_of(:time) }
  it { should allow_mass_assignment_of(:latitude) }
  it { should allow_mass_assignment_of(:longitude) }
  it { should allow_mass_assignment_of(:sponsored) }
  it { should allow_mass_assignment_of(:tentative) }
  it { should allow_mass_assignment_of(:link) }
  it { should have_many(:users) }
end
