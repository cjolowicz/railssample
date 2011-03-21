require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = 'Ruby on Rails Tutorial Sample App'
  end

  describe "GET 'home'" do
    it "should be successful" do
      get :home
      response.should be_success
    end

    it "should have the right title" do
      get :home
      response.should have_selector("title",
                                    :content => "#{@base_title} | Home")
    end

    describe "when signed in" do
      before(:each) do
        @user = test_sign_in Factory(:user)
      end

      it "should have the right follower/following counts" do
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.follow! @user
        get :home
        response.should have_selector('a', :href    => following_user_path(@user),
                                           :content => '0 following')
        response.should have_selector('a', :href    => followers_user_path(@user),
                                           :content => '1 follower')
      end
    end
  end

  describe "GET 'contact'" do
    before(:each) do
      get :contact
    end

    it "should be successful" do
      response.should be_success
    end

    it "should have the right title" do
      response.should have_selector("title",
                                    :content => "#{@base_title} | Contact")
    end
  end

  describe "GET 'about'" do
    before(:each) do
      get :about
    end

    it "should be successful" do
      response.should be_success
    end

    it "should have the right title" do
      response.should have_selector("title",
                                    :content => "#{@base_title} | About")
    end
  end
end
