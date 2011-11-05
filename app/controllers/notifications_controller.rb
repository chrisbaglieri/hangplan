class NotificationsController < ApplicationController
  def index
    authorize! :read, :notifications
    @pending_friend_invites = current_user.pending_invited_by
    @pending_invites = current_user.pending_invited
  end
end
