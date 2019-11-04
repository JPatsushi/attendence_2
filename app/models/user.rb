class User < ApplicationRecord
  has_many :time_cards, dependent: :destroy
  has_many :monthly_authentications, dependent: :destroy
  
  attr_accessor :remember_token, :activation_token, :reset_token
  
  
  
  #before_save { self.email = email.downcase } 
  #before_save { email.downcase! }
  before_save   :downcase_email
  before_create :create_activation_digest
   
  validates :name,  presence: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  def User.check_password_confirmation(password)
    unless password 
      validates :password, confirmation: true
    end
  end
  
  # validates :password, length: {minimum: 6}, on: :update, allow_blank: true

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
   # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # アカウントを有効にする
  def activate
    # update_attribute(:activated,    true)
    # update_attribute(:activated_at, Time.zone.now)
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  
  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    # update_attribute(:reset_digest,  User.digest(reset_token))
    # update_attribute(:reset_sent_at, Time.zone.now)
    update_columns(reset_digest:  User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  
   # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  # # 試作feedの定義
  # # 完全な実装は次章の「ユーザーをフォローする」を参照
  # def feed
  #   Micropost.where("user_id = ?", id)
  # end
  
  # # ユーザーのステータスフィードを返す
  # def feed
  #   Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
  # end
  
  # # ユーザーのステータスフィードを返す
  # def feed
  #   Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
  #   following_ids: following_ids, user_id: id)
  # end
  
  # ユーザーのステータスフィードを返す。 サブセレクト
  # def feed
    
    
  #   # following_ids = "SELECT followed_id FROM relationships
  #   #                 WHERE follower_id = :user_id"
  #   # Micropost.where("user_id IN (#{following_ids})
  #   #                  OR user_id = :user_id", user_id: id)
                     
  #   Micropost.where("user_id IN (?) OR user_id = ? OR in_reply_to = ? ", following_ids, id, "@#{id}\-#{name.sub(/\s/,'-')}")                
  #   # Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id) 
                     
  # end
  
  # def feed(user)
  #   following_ids = "SELECT followed_id FROM relationships
  #                   WHERE follower_id = :user_id"
  #   Micropost.including_replies(user).where("user_id IN (#{following_ids})
  #             OR user_id = :user_id", user_id: id) 
  # end
  
  # # ユーザーをフォローする
  # def follow(other_user)
  #   active_relationships.create(followed_id: other_user.id)
  # end

  # # ユーザーをフォロー解除する
  # def unfollow(other_user)
  #   active_relationships.find_by(followed_id: other_user.id).destroy
  # end

  # # 現在のユーザーがフォローしてたらtrueを返す
  # def following?(other_user)
  #   following.include?(other_user)
  # end
  
    def self.import(file)
      CSV.foreach(file.path, headers: true) do |row|
  
        user = User.find_by(name: row[1]) ? User.find_by(name: row[1]) : User.new()
        
        #byebug
        row_hash = row.to_hash 
        depart = row[3]
        password = row[11]
        id = row[0].to_i
        
        tmp_hash = row_hash.slice(*updatable_attributes)
        tmp_hash.merge!({depart: depart, password_confirmation: password, activated: true, activated_at: Time.zone.now})
        user.attributes = tmp_hash
        user.save
        User.where(name: row[1]).update_all(id: id)
        # User.find(104).update_column(:id,106) これも変更可能
        
        # 参考用:
        # def self.attributes_protected_by_default
        #   [] # ["id", ..other]
        # end
      end
    end
  
    def self.updatable_attributes
      ["name","email","employee_number","uid", "basic_work_time", "designated_work_start_time",
      "designated_work_end_time", "superior", "admin", "password"]
    end
  
  
  
     private
  
      # メールアドレスをすべて小文字にする
      def downcase_email
        self.email = email.downcase
      end
  
      # 有効化トークンとダイジェストを作成および代入する
      def create_activation_digest
        self.activation_token  = User.new_token
        self.activation_digest = User.digest(activation_token)
      end
end
