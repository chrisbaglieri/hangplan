class CommentsController < ApplicationController
  load_and_authorize_resource :plan
  load_and_authorize_resource :comment, :through => :plan, :shallow => true

  def create
    @comment.user = current_user
    @comment.save
    respond_with @comment.plan
  end

  def destroy
    @comment.destroy
    respond_with @comment.plan
  end

end
