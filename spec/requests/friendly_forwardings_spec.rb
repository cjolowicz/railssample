require 'spec_helper'

describe "FriendlyForwardings" do
  it "should forward to the request page after signin" do
    user = Factory(:user)
    visit edit_user_path(user)
    # redirect to signin
    fill_in :email, :with => user.email
    fill_in :password, :with => user.password
    click_button
    # redirect to users/edit
    response.should render_template('users/edit')
  end
end
