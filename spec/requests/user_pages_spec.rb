require 'spec_helper'

describe "UserPages" do

subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1', text: 'Sign up') }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1', text: "#{user.first_name} #{user.last_name}") }
    it { should have_selector('title', text: user.first_name) }
  end

  describe "signup" do
    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "after submission" do
      before { click_button submit }

      # it { should have_selector('title', text: 'Sign up') }
      it { should have_content('error') }
    end

    describe "with valid information" do
      before do
        fill_in "First name",     with: "Tucker"
        fill_in "Last name",     with: "Fudpucker"
        fill_in "Email",     with: "tucker@fudpucker.com"
        fill_in "Password",     with: "ttfudpucker"
        fill_in "Confirmation",     with: "ttfudpucker"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        # it { should have_selector('title', text: user.first_name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end
    end
 # end

    describe "edit" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        visit edit_user_path(user)
      end

      describe "page" do
        it { should have_selector('h1', text: "Update your profile") }
        it { should have_selector('title', text: "Edit user") }
        it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      let (:new_first_name) { "New First Name" }
      let (:new_last_name) { "New Last Name" }
      let (:new_email) { "new@example.com" }
      before do
        fill_in "First name",     with: new_first_name
        fill_in "Last name",     with: new_last_name
        fill_in "Email",     with: new_email
        fill_in "Password",     with: user.password
        fill_in "Confirmation",     with: user.password
        click_button "Save changes"
      end
      # it { should have_selector('title', text: user.first_name) }
        it { should have_selector('div.alert.alert-success') }
        it { should have_link('Sign out', href: signout_path) }
        specify { user.reload.first_name.should == new_first_name }
        specify { user.reload.last_name.should == new_last_name }
        specify { user.reload.email.should == new_email }
      end
    end
  end
end
