class NotificationsController < ApplicationController
  def index
    authorize! :read, :notifications
    @notifications = []
    @pending_friend_requests = current_user.pending_invited_by
  end
end
