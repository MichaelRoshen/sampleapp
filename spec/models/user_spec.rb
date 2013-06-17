require 'spec_helper'

describe User do 

  before do
    @user = User.new(name: "Example User", 
      email: "user@example.com",
      password: "foobar",
      password_confirmation: "foobar")
  end
  subject { @user }
  it { should respond_to(:name) }
  it { should respond_to(:admin) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate)}
  it { should respond_to(:remember_token) }
  it { should respond_to(:microposts) }
  it { should respond_to(:relationships) }
  it { should respond_to(:feed) }
  it { should be_valid }

  describe "with admin attribute set to 'true'" do
    #使用 toggle! 方法把 admin 属性的值从 false 转变成 true
    before { @user.toggle!(:admin)}
    #be_admin 对应admin? 方法,rails自己生成
    it { should be_admin }
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "when name is not present" do
    before { @user.name = "" }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = "" }
    it { should_not be_valid }
  end

  describe "when name is to long" do 
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      address = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_bar.com foo@bar+baz.com]
      address.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      address = %w[user@foo.COM A_US-ER@f.b.org best.lst@foo.jp a+b@baz.cn]
      address.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do 
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = "" }
    it { should_not be_valid }
  end

  describe "when password dismatch confirmation " do 
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end
  
  describe "with a password that's to short" do
    before { @user.password = @user.password_confirmation = "a" * 5}
    it { should be_invalid }
  end

  describe "return value of authenticate method"  do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it {should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end

  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExaMple.CoM" }
    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
  end

  describe "micropost associations" do
    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end
    it "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy association microposts" do
      microposts = @user.microposts.dup
      @user.destroy
      microposts.should_not be_empty
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status" do
      let(:unfollowd_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      its(:feed) { should include(newer_micropost)}
      its(:feed) { should include(older_micropost)}
      its(:feed) { should_not include(unfollowd_post)}
    end
  end
































end
