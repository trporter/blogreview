class LikesController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.liked_posts
  end

  def create
    @like = current_user.likes.new
    post = Post.find params[:post_id]
    @like.post = post
    respond_to do |format|
      if @like.save
        format.html {redirect_to post, notice: "Liked!"}
        format.js {render :create_success}
      else
        format.html {redirect_to post, alert: "Can't Like!"}
        format.js {render :create_fail}
      end
    end
  end

  def destroy
    @like = current_user.likes.find params[:id]
    post = Post.find params[:post_id]
    @like.destroy
    respond_to do |format|
      format.html {redirect_to post, notice: "Unliked"}
      format.js {render}
    end
  end

end
