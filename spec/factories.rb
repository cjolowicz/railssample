Factory.define :user do |user|
  user.name                  'Claudio Jolowicz'
  user.email                 'claudio@dealloc.org'
  user.password              'foobar'
  user.password_confirmation 'foobar'
end

Factory.sequence :email do |n|
  "user-#{n+1}@example.com"
end

Factory.define :micropost do |micropost|
  micropost.content     'Lorem ipsum'
  micropost.association :user
end
