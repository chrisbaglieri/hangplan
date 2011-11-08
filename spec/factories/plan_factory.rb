Factory.define :plan do |plan|
  plan.name 'Foo'
  plan.location  'Foo'
  plan.start_date_s DateTime.now.strftime('%m/%d/%Y')
  plan.start_time_s DateTime.now.strftime('%H:%M')
  plan.tentative false
  plan.association :owner, :factory => :user
  plan.privacy 'public'
end