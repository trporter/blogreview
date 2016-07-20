class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @vote = Vote.new vote_params
    @vote.user = current_user
    @vote.post = current_post

    respond_to do |format|
      if @vote.save
        format.html {redirect_to current_post, notice: "voted"}
        format.js {render :create_success}
      else
        format.html {redirect_to current_post, alert: "couldn't vote"}
        format.js {render :create_fail}
      end
    end
  end

  def destroy
    @vote = Vote.find_by_id params[:id]
    #do the logic here.
    current_user

    respond_to do |format|
      if @vote
        @vote.destroy
        format.html {redirect_to current_post, notice: "vote removed"}
        format.js {render :create_success}
      else
        format.html {redirect_to current_post, alert: "couldnt vote"}
        format.js { render }
      end
    end
  end

  def update
    @vote = Vote.find_by_id params[:id]
    respond_to do |format|
      if @vote
        @vote.update(vote_params)
        format.html {redirect_to current_post, notice: "vote changed"}
        format.js { render }
      else
        format.html {redirect_to current_post, alert: "vote unchanged"}
        format.js { render }
      end
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:is_up)
  end

end
