namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
  end
end

def make_users
  admin = User.create!(:name                  => 'Example User',
                       :email                 => 'user@example.com',
                       :password              => 'foobar',
                       :password_confirmation => 'foobar')
  admin.toggle!(:admin)
  99.times do |n|
    User.create!(:name                  => Faker::Name.name,
                 :email                 => "user-#{n+1}@example.com",
                 :password              => 'foobar',
                 :password_confirmation => 'foobar')
  end
end

def make_microposts
  User.all(:limit => 6).each do |user|
    50.times do
      user.microposts.create!(:content => Faker::Lorem.sentence(5))
    end
  end
end
