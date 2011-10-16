Factory.define :Participant do |participant|
  participant.association :user
  participant.association  :plan
  participant.points 1
end