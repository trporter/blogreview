class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]

  def create
    @comment = Comment.new comment_params
    @post = Post.find params[:post_id]
    @comment.post = @post
    respond_to do |format|
      if @comment.save
        format.html {redirect_to post_path(@post), notice: "Comment Created"}
        format.js {render :create_success}
      else
        format.html {render "/posts/show"}
        format.js {render :create_fail}
      end
    end
  end

  def destroy
    post = Post.find params[:post_id]
    @comment = Comment.find params[:id]
    @comment.destroy
    respond_to do |format|
      format.html {redirect_to post_path(post), notice: "Comment deleted"}
      format.js {render}
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
