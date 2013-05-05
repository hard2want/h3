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
    end
  end
end
