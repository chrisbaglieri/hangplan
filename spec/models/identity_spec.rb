require 'spec_helper'

describe Identity do
  it { should belong_to(:user) }
  it { should validate_presence_of(:source) }
  it { should validate_presence_of(:identifier) }
  it { should validate_presence_of(:access_token) }
  it { should allow_mass_assignment_of(:source) }
  it { should allow_mass_assignment_of(:identifier) }
  it { should allow_mass_assignment_of(:access_token) }
end
