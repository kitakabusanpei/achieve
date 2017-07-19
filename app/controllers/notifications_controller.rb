class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    # 自分の通知のみ取得し、通知を新しい順に並び替え、未読の通知のみ表示させる。
    @notifications = Notification.where(user_id: current_user.id).where(read: false).order(created_at: :desc)
  end


end
