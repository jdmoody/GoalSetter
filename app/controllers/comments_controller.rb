class CommentsController < ApplicationController
  def new

  end

  def create
    @comment = comment_class.find(params[comment_id]).comments.new(comment_params)
    @comment.author_id = current_user.id
    if @comment.save
      redirect_to commentable_url(comment_id)
    else
      flash[:errors] = ["You got an error son !!!"]
      redirect_to commentable_url(comment_id)
    end
  end

  def destroy

  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def comment_class
    if params.keys.include?('user_id')
      User
    else
      Goal
    end
  end

  def comment_id
    if params.keys.include?("user_id")
      :user_id
    else
      :goal_id
    end
  end

  def commentable_url(id)
    if params.keys.include?("user_id")
      user_url(params[id])
    else
      goal_url(params[id])
    end
  end

end
