Factory.define :plan do |plan|
  plan.name 'Foo'
  plan.location  'Foo'
  plan.time DateTime.now
  plan.association :owner, :factory => :user
end