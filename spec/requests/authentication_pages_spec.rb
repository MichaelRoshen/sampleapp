require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }
  describe "signin page" do
    before { visit signin_path }
    it { should have_selector('h1', text: "Sign In") }
    it { should have_selector('title', text: "Sign In") }
  end

  describe "signin" do
    before { visit signin_path }
    
    describe "with invalid information" do
      before { click_button "Sign In" }
      it { should have_selector('title', text: "Sign In") }
      it { should have_selector('div.alert.alert-error', text: "Invalid")} 

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector("div.alert.alert-error")}
      end
    end

    describe "with valid information" do
      let(:user) {FactoryGirl.create(:user) }
      before do 
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign In"
      end
      it { should have_selector('title', text: user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Users', href: users_path) }
      it { should have_link('Setting', href: edit_user_path(user)) }
      it { should have_link("Sign Out", href: signout_path) }
      it { should_not have_link("Sign In", href: signin_path)}
    end
  end

  describe "authenticate" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      describe "visiting the edit page" do
        before { visit edit_user_path(user) }
        it { should have_selector('title', text: "Sign In") }
      end
      
      describe "visiting the users index" do
        before { visit users_path }
        it { should have_selector('title', text: "Sign In") }
      end

      describe 'submitting to the update action' do
        before { put user_path(user) }
        specify { response.should redirect_to(signin_path)}
      end

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign In"
        end
        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_selector('title', text: "Edit user")
          end

          describe "when sign in again" do
            before { sign_in(user)}
            it "should render the default (profile) page" do
              page.should have_selector('title', text: user.name)
            end
          end
        end
      end

      describe "in the microposts controller" do
        #没有登录的用户查看微博时，重定向到登录页面
        describe "submmit to the create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path)}
        end

        describe "submmit to the destory action" do
          let(:m1) { FactoryGirl.create(:micropost) }
          before { delete micropost_path(m1) }
          specify { response.should redirect_to(signin_path)}
        end
        
      end
    end

    describe "as a wrong user" do
      let(:user) { FactoryGirl.create(:user)}
      #用指定的 Email 替换默认值，然后创建用户
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com")}
      before { sign_in user}
      describe "visiting user#edit page" do
        before { visit edit_user_path(wrong_user) }
        it {should_not have_selector('title', text: "Edit user")}
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user)}
        specify { response.should redirect_to(root_path)}
      end
      
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end

  end
end
