Factory.define :identity do |identity|
  identity.association :user, :factory => :user
  identity.identifier { "#{identity.ordinalize}" }
  identity.access_token { "#{identity.ordinalize}" }
end

Factory.define :facebook, :parent => :identity do |facebook|
  facebook.source { "facebook" }
end