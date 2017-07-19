class MessagesController < ApplicationController
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

  def index
    @messages = @conversation.messages # 会話にひもづくメッセージを取得
    if @messages.length > 10 # 10だけにする
      @over_ten = true
      @messages = @messages[-10..-1]
    end

    if params[:m] # 会話にひもづくメッセージをすべて取得
      @over_ten = false # 10のフラグ解除
      @messages = @conversation.messages
    end

    if @messages.last
      if @messages.last.user_id != current_user.id # 最新が自分以外のものなら既読状態にする
        @messages.last.read = true
      end
    end

    @message = @conversation.messages.build
  end

  def create
    @message = @conversation.messages.build(message_params) # 会話にひもづくメッセージを生成
    if @message.save
      redirect_to conversation_messages_path(@conversation) # メッセージ一覧の画面に遷移
    end
  end

  private
  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end
