class Conversation < ActiveRecord::Base
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User' # 会話の受け手がユーザモデルから参照できるようにアソシエーションを設定
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  has_many :messages, dependent: :destroy
  validates_uniqueness_of :sender_id, scope: :recipient_id #送り手は受け手と重複しないことを制御しチェックする,属性の値が一意であることを検証するメソッド
  scope :between, -> (sender_id,recipient_id) do #チェックする仕組みとして送り手と受け手の「組み合わせ」で判定する
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND  conversations.recipient_id =?)", sender_id, recipient_id, recipient_id, sender_id)
  end

  def target_user(current_user)
    if sender_id == current_user.id
      User.find(recipient_id)
    elsif recipient_id == current_user.id
      User.find(sender_id)
    end
  end
end
