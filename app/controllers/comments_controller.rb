class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params) # Blogをパラメータの値から探し出し,Blogに紐づくcommentsとしてbuildします。
    @blog = @comment.blog
    # buildメソッドを使用して、@commentに紐付けたインスタンスは@comment.save時に一緒に保存されます
    @notification = @comment.notifications.build(user_id: @blog.user.id) # commentに紐付いた、notificationを作成
    respond_to do |format|
      if @comment.save
        format.html { redirect_to blog_path(@blog), notice: 'コメントを投稿しました。' }
        format.js { render :index }

        unless @comment.blog.user_id == current_user.id
          Pusher.trigger("user_#{@comment.blog.user_id}_channel", 'comment_created', {
            message: 'あなたの作成したブログにコメントが付きました'
          })
        end
        Pusher.trigger("user_#{@comment.blog.user_id}_channel", 'notification_created', {
          unread_counts: Notification.where(user_id: @comment.blog.user.id, read: false).count
        })
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to blog_path(@blog), notice: 'コメント削除しました。' }
      format.js { render :index }
      flash[:notice_blog] = "コメントを削除しました。"
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:blog_id, :content)
    end
end
# raise
# binding.pry
