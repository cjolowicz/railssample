require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
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
end
