class ConversationsController < ApplicationController
  before_action :authenticate_user!
  def index
    @users = User.all
    @conversations = Conversation.all
  end

  def create
    if Conversation.between(params[:sender_id], params[:recipient_id]).present? # 該当のユーザ間での会話が過去に存在しているかを確認する式
      @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first # 存在した場合、その会話を取得する
    else
      @conversation = Conversation.create!(conversation_params) # 過去に一件も存在しなかった場合←で強制的にメッセージを生成します
    end

    redirect_to conversation_messages_path(@conversation)
  end

  private
  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
end
