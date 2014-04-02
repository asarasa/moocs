require 'spec_helper'

describe UsersController do
	before :each do
		@locale = I18n.default_locale
	end

	shared_examples("public access to users") do
		describe "GET #new" do
			it "assigns a new User to @user" do
				get :new, locale: @locale
				expect(assigns(:user)).to be_a_new(User)
			end
			it "renders the :new template" do
				get :new, locale: @locale
				expect(response).to render_template 'new'
			end
		end

		describe "POST #create" do
			context "with valid attributes" do
				it "saves the new user in the database" do
					expect {
						post :create, locale: @locale, user: attributes_for(:user)
					}.to change(User, :count).by(1)
				end
				it "redirects to root_url" do
					post :create, locale: @locale, user: attributes_for(:user)
					expect(response).to redirect_to root_url
				end
			end

			context "with invalid attributes" do
				it "does not save the new user in the database" do
					expect {
						post :create, locale: @locale, user: attributes_for(:invalid_user)
					}.to change(User, :count).by(0)
				end

				it "re-renders the new template" do
					post :create, locale: @locale, user: attributes_for(:invalid_user)
					expect(response).to render_template 'new'
				end
			end
		end
	end

	shared_examples("full access to users") do
		describe "GET #edit" do
			it "assigns the current user to @user" do
				get :edit, { locale: @locale, id: @user }
				expect(assigns(:user)).to eq @user
			end

			it "renders the :edit template" do
				get :edit, { locale: @locale, id: @user}
				expect(response).to render_template 'edit'
			end
		end

		describe "GET #user_courses" do
			it "renders the user_courses template" do
				get :user_courses, locale: @locale
				expect(response).to render_template 'user_courses'
			end
		end

		describe "GET #user_resources" do
			it "renders the user_resources template" do
				get :user_resources, locale: @locale
				expect(response).to render_template 'user_resources'
			end
		end
	end

  describe "user access" do
    before :each do
    	@user = create(:user)
    	set_user_session @user
    end

    it_behaves_like "full access to users"

    describe "GET #new" do
    	it "user can't sign up if has already logged" do
    		get :new, locale: @locale
    		expect(response).to redirect_to login_url
    	end
    end

    describe "GET #create" do
    	it "user can't sign up if has already logged" do
    		get :create, locale: @locale, user: attributes_for(:user)
    		expect(response).to redirect_to login_url
    	end
    end
  end

  describe "guest access" do
    it_behaves_like "public access to users"

    describe "GET #edit" do
    	it "requires login" do
    		user = create(:user)
    		get :edit, { locale: @locale, id: user }
    		expect(response).to redirect_to login_url
    	end
    end

    describe "GET #show" do
    	it "requires login" do
    		user = create(:user)
    		get :show, { locale: @locale, id: user }
    		expect(response).to redirect_to login_url
    	end
    end

    describe "GET #user_courses" do
    	it "requires login" do
    		get :user_courses, locale: @locale
    		expect(response).to redirect_to login_url
    	end
    end

    describe "GET #user_resources" do
    	it "requires login" do
    		get :user_resources, locale: @locale
    		expect(response).to redirect_to login_url
    	end
    end

    describe "PUT #update" do
    	it "requires login" do
	    	put :update, locale: @locale, id: create(:user), user: attributes_for(:user)
    		expect(response).to redirect_to login_url    		
    	end
    end

  end  	
end
