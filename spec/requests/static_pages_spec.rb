require 'spec_helper'

describe "StaticPages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',:text => heading) }
    it { should have_selector('title',:text => full_title(page_title))}
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) { "Sample App" }
    let(:page_title) { "" }
    it_should_behave_like "all static pages"
    it { should have_content('Sample App') }
  end 

  describe "Help page" do 
    before { visit help_path }
    let(:heading) { "Help" }
    let(:page_title) { "Help" } 
    it_should_behave_like "all static pages"
    it { should have_content('help') }
  end

  describe "About page" do 
    before { visit about_path }
    let(:heading) { "About" } 
    let(:page_title){ "About" }
    it_should_behave_like "all static pages"
    it { should have_content('About Us')}
   end 

  describe "Layout" do
    it "should have the right links on the layouts" do
    visit root_path
    click_link "About"
    should have_selector "title", text: full_title("About")
    click_link "Help"
    should have_selector "title", text: full_title("Help")
    click_link "Home"
    click_link "Sign up now!"
    should have_selector "title", text: full_title("Sign Up")
    end
  end

end
