require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => 'Example User', :email => 'user@example.com' }
  end

  it "should create a new instance given valid attributes" do
    User.create! @attr
  end

  it "should require a name" do
    user = User.new @attr.merge(:name => '')
    user.should_not be_valid
  end

  it "should require an email address" do
    user = User.new @attr.merge(:email => '')
    user.should_not be_valid
  end

  it "should reject names that are too long" do
    name = 'a' * 51
    user = User.new @attr.merge(:name => name)
    user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      user = User.new @attr.merge(:email => address)
      user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      user = User.new @attr.merge(:email => address)
      user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    User.create! @attr
    user = User.new @attr
    user.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    address = @attr[:email].upcase
    User.create! @attr.merge(:email => address)
    user = User.new @attr
    user.should_not be_valid
  end
end
