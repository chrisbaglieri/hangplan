require 'spec_helper'

describe Identity do
  it { should belong_to(:user) }
  it { should validate_presence_of(:source) }
  it { should validate_presence_of(:identity) }
  it { should validate_presence_of(:access_token) }
  it { should allow_mass_assignment_of(:source) }
  it { should allow_mass_assignment_of(:identity) }
  it { should allow_mass_assignment_of(:access_token) }
  it { should allow_value("facebook").for(:source) }
  it { should allow_value("twitter").for(:source) }
end
