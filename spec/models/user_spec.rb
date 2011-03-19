require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
      :name                  => 'Example User',
      :email                 => 'user@example.com',
      :password              => 'foobar',
      :password_confirmation => 'foobar'
    }
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

  describe "password validations" do
    it "should require a password" do
      user = User.new @attr.merge(:password => '', :password_confirmation => '')
      user.should_not be_valid
    end

    it "should require a matching password confirmation" do
      user = User.new @attr.merge(:password_confirmation => 'invalid')
      user.should_not be_valid
    end

    it "should reject short passwords" do
      password = 'a' * 5
      user = User.new @attr.merge(:password => password,
                                  :password_confirmation => password)
      user.should_not be_valid
    end

    it "should reject long passwords" do
      password = 'a' * 41
      user = User.new @attr.merge(:password => password,
                                  :password_confirmation => password)
      user.should_not be_valid
    end
  end

  describe "password encryption" do
    before(:each) do
      @user = User.create! @attr
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if the passwords don't match" do
        @user.has_password?('invalid').should be_false
      end
    end

    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        user = User.authenticate(@attr[:email], 'invalid')
        user.should be_nil
      end

      it "should return nil for an email address with no user" do
        user = User.authenticate("bar@foo.com", @attr[:password])
        user.should be_nil
      end

      it "should return the user on email/password match" do
        user = User.authenticate(@attr[:email], @attr[:password])
        user.should == @user
      end
    end
  end

  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
end
