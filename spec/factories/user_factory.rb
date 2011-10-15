Factory.sequence :email do |email|
  "#{email.ordinalize}@email.com"
end

Factory.define :user do |user|
  user.email { Factory.next :email }
  user.password { "password" }
  user.password_confirmation { "password" }
end