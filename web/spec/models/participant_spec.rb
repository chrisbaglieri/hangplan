require 'spec_helper'

describe Participant do
  before do
    @participant = Factory(:participant)
  end
  
  it { should belong_to(:user) }
  it { should belong_to(:plan) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:plan_id) }
  it { should ensure_inclusion_of(:points).in_range(-1..1) }
end
