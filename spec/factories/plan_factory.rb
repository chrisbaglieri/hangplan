Factory.define :plan do |plan|
  plan.name 'Foo'
  plan.location  'Foo'
  plan.date DateTime.now
  plan.tentative false
  plan.association :owner, :factory => :user
end