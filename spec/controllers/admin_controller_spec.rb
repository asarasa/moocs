require 'spec_helper'

describe AdminController do
  before :each do
    @locale = I18n.default_locale
  end

  describe 'guest access' do

    describe "GET 'users'" do
      it "redirects to login_url" do
        get :users, locale: @locale
        expect(response).to redirect_to login_url
      end
    end

    describe "GET 'courses'" do
      it "redirects to login_url" do
        get :courses, locale: @locale
        expect(response).to redirect_to login_url
      end
    end

    describe "GET 'resources'" do
      it "redirects to login_url" do
        get :resources, locale: @locale
        expect(response).to redirect_to login_url
      end
    end
  end

  describe "user access" do
    before :each do
      @user = create(:user)
      set_user_session @user
    end

    describe "GET 'users'" do
      it "redirects to root_url" do
        get :users, locale: @locale
        expect(response).to redirect_to root_url
      end
    end

    describe "GET 'courses'" do
      it "redirects to root_url" do
        get :courses, locale: @locale
        expect(response).to redirect_to root_url
      end
    end

    describe "GET 'resources'" do
      it "redirects to root_url" do
        get :resources, locale: @locale
        expect(response).to redirect_to root_url
      end
    end
  end

  describe 'admin access' do
    before :each do
      @user = create(:admin)
      set_user_session @user
    end    

    describe "GET 'users'" do
      it "populates an array with all users" do
        user1 = create(:user)
        user2 = create(:user)
        get :users, locale: @locale
        expect(assigns(:users)).to match_array([user1, user2, @user])
      end

      it "renders the users template" do
        get :users, locale: @locale
        expect(response).to render_template 'users'
      end
    end

    describe "GET 'courses'" do
      it "populates an array with all courses" do
        course1 = create(:course)
        course2 = create(:course)
        get :courses, locale: @locale
        expect(assigns(:courses)).to match_array([course1, course2])
      end

      it "renders the courses template" do
        get :courses, locale: @locale
        expect(response).to render_template 'courses'
      end
    end

    describe "GET 'resources'" do
      it "renders the resources template" do
        get :resources, locale: @locale
        expect(response).to render_template 'resources'
      end
    end
  end  
end
