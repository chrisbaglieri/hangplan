Factory.define :plan do |plan|
  plan.name 'Foo'
  plan.location  'Foo'
  plan.start_at DateTime.now
  plan.association :owner, :factory => :user
end