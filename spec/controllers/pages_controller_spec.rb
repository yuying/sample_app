require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector("title",
                        :content => @base_title + " | Home")
    end

    describe "for signed-in users" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
      end

      it "should show the correct number of microposts in the sidebar" do
        @mp1 = Factory(:micropost, :user => @user)
        get :home
        response.should have_selector("span.microposts", :content => "1 micropost")
        @mp2 = Factory(:micropost, :user => @user)
        get :home
        response.should have_selector("span.microposts", :content => "2 microposts")
      end

      it "should pagination microposts" do
        35.times do |n|
          Factory(:micropost, :user => @user, :content => "Foo bar#{n+1}")
        end
        get :home
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/?page=2",
                                           :content => "Next")
      end
    end


  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
  
  it "should have the right title" do
    get 'contact'
    response.should have_selector("title",
                    :content => @base_title + " | Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_succes
    end
  
  it "should have the right title" do
    get 'about'
    response.should have_selector("title",
                    :content => @base_title + " | About")
    end
  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

  it "should have the right title" do
    get 'help'
    response.should have_selector("title",
                      :content => @base_title + " | Help")
   end
 end

end
