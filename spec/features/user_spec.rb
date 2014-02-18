require 'spec_helper'

feature 'User browsing the website' do
  context "on homepage" do
    it "sees a list of recent posts titles" do
      Post.create!(title: "super interesting title", content: "some content")
      visit posts_path
      page.should have_content("Super Interesting Title")
      # given a user and a list of posts
      # user visits the homepage
      # user can see the posts titles
    end

    it "can click on titles of recent posts and should be on the post show page" do
      Post.create!(title: "super interesting title", content: "some content")
      visit posts_path
      click_link "Super Interesting Title"
      page.should have_content("some content")
      # given a user and a list of posts
      # user visits the homepage
      # when a user can clicks on a post title they should be on the post show page
    end
  end

  context "post show page" do
    it "sees title and body of the post" do
      post = Post.create!(title: "super interesting title", content: "some content")
      visit post_path(post)
      page.should have_content("Super Interesting Title")
      page.should have_content("some content")
      # given a user and post(s)
      # user visits the post show page
      # user should see the post title
      # user should see the post body
    end
  end
end
