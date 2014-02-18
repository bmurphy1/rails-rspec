require 'spec_helper'

feature 'Admin panel' do

  let(:post) {Post.create!(title: "super interesting title", content: "some content")}

  def basic_auth(user, password)
    encoded_login = ["#{user}:#{password}"].pack("m*")
    page.driver.header 'Authorization', "Basic #{encoded_login}"
  end

  before do
    basic_auth('geek', 'jock')
  end

  context "on admin homepage" do
    it "can see a list of recent posts" do
      visit admin_posts_path
      page.should have_content("Welcome to the admin panel!")
      end
    it "can edit a post by clicking the edit link next to a post" do
      Post.create!(title: "super interesting title", content: "some content")
      visit admin_posts_path
      click_on "Edit"
      page.should have_content("Edit")
    end

    it "can delete a post by clicking the delete link next to a post" do
      post = Post.create!(title: "super interesting title", content: "some content")
      visit admin_posts_path
      click_on "Delete"
      expect(Post.where(id: post.id)).to eq([])
    end

    it "can create a new post and view it" do
       visit new_admin_post_url

       expect {
         fill_in 'post_title',   with: "Hello world!"
         fill_in 'post_content', with: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat."
         page.check('post_is_published')
         click_button "Save"
       }.to change(Post, :count).by(1)

       page.should have_content "Published: true"
       page.should have_content "Post was successfully saved."
     end
  end

  context "editing post" do
    it "can mark an existing post as unpublished" do
      post = Post.create!(title: "super interesting title", content: "some content", is_published: true)
      visit admin_posts_path
      click_on "Edit"
      page.uncheck('post_is_published')
      click_button "Save"
      page.should have_content "Published: false"
    end
  end

  context "on post show page" do
    it "can visit a post show page by clicking the title" do
      post = Post.create!(title: "super interesting title", content: "some content")
      visit admin_posts_path
      click_on post.title
      page.should have_content post.title
    end

    it "can see an edit link that takes you to the edit post path" do
      Post.create!(title: "super interesting title", content: "some content")
      visit admin_posts_path
      click_on "Edit"
      page.should have_content("Edit")
    end

    it "can go to the admin homepage by clicking the Admin welcome page link" do
      visit admin_posts_path
      click_on "Home"
      page.should have_content("Welcome to the admin panel!")
    end
  end
end
