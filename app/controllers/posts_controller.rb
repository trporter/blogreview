class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new post_params
    @post.user = current_user
    if @post.save
      if @post.tweet_it
        client = Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
          config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
          config.access_token        = current_user.twitter_token
          config.access_token_secret = current_user.twitter_secret
        end
        client.update "#Question: #{post.title} #{question_path(post)}"
      end
      flash[:notice] = "Post created!"
      redirect_to post_path(@post)
    else
      flash[:alert] = "Post not created!"
      render :new
    end
  end

  def index
    @posts = Post.order(created_at: :desc)
  end

  def show
    @post = Post.find params[:id]
    @comments = Comment.new
    # @like = @post.like_for(current_user)
  end


  def edit
    @post = Post.find params[:id]
  end

  def update
    @post = Post.find params[:id]
    if @post.update post_params
      redirect_to post_path(@post), notice: "Post Updated"
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find params[:id]
    @post.destroy
    redirect_to posts_path, notice: "Post deleted"
  end

  def current_user_vote
    @post.vote_for(current_user)
    # @posts.vote_for(current_user)
  end
  helper_method :current_user_vote

  private

  def post_params
    params.require(:post).permit(:title, :body, :category_id, :tweet_it)
  end

end
