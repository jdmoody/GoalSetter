class GoalsController < ApplicationController
  before_action :authenticate
  before_action :requires_owner, only: [:edit, :update, :destroy, :complete, :reactivate]

  def index
    if current_user.id == params[:user_id].to_i
      @goals = Goal.where(user_id: params[:user_id])
    else
      @goals = Goal.where(user_id: params[:user_id], is_private: false)
    end
  end

  def show
    @goal = Goal.find(params[:id])
  end

  def new
    @goal = Goal.new
  end

  def create
    @goal = current_user.goals.new(goal_params)
    if @goal.save
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def edit
    @goal = Goal.find(params[:id])
  end

  def update
    @goal = Goal.find(params[:id])
    if @goal.update_attributes(goal_params)
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :edit
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy
    redirect_to user_goals_url(current_user)
  end

  def complete
    @goal = Goal.find(params[:id])
    @goal.completed = true
    @goal.save
    redirect_to goal_url(@goal)
  end

  def reactivate
    @goal = Goal.find(params[:id])
    @goal.completed = false
    @goal.save
    redirect_to goal_url(@goal)
  end

  private
  def goal_params
    params.require(:goal).permit(:title, :body, :is_private, :completed)
  end

  def requires_owner
    redirect_to root_url unless current_user.id == Goal.find(params[:id]).user_id
  end
end
