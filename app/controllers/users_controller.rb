class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  # before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :index]
  before_action :correct_but_admin_user, only: [:show, :edit, :update]
  
  def index
    if params[:q]
      @q = User.ransack(search_params, activated: true)
      @users = @q.result(distinct: true).page(params[:page])
      @title = "検索結果"
    else  
      @q = User.ransack(activated_true: true)
      # @users = User.paginate(page: params[:page])
      # @users = User.where(activated: true).paginate(page: params[:page])
      @title = "ユーザ一覧"
    end
      @users = @q.result.page(params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)    
    if @user.save
      @user.activate
      # @user.send_activation_email
      log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user #redirect_to user_url(@user)と同じ
      flash[:info] = "作成及び登録成功"
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    if current_user.admin?

      @user = User.find(params[:id])
       
      if params[:password]
        password = params[:password]
        @user.attributes = {password: password, password_confirmation: password}
      end
      
      if @user.update_attributes(user_params)
        flash[:success] = "#{@user.name}のプロフィールを更新しました"
        redirect_to users_path
      else
        @q = User.ransack(activated_true: true)
        @title = "ユーザ一覧"
        @users = @q.result.page(params[:page])
        render 'index'
      end
    else
      @user = User.find(params[:id])
      password = params[:password]
      User.check_password_confirmation(password)
      if @user.update_attributes(user_params)
        flash[:success] = "プロフィールを更新しました"
        redirect_to @user
      else
        render 'edit'
      end
    end
  end
  
  def destroy
    user = User.find(params[:id])
    name = user.name
    user.destroy
    flash[:success] = "#{name}を削除しました"
    redirect_to users_url
  end
  
  #出勤社員一覧
  def working_member
    time_cards = TimeCard.where.not(in_at: nil).where(out_at: nil)
    @members = []
    time_cards.each {|time_card| @members << time_card.user}
    #@members = User.joins(:time_cards).where.not(time_cards: {in_at: nil}).where(time_cards: {out_at: nil})
    # User.where("name like :name", name: "上長%").pluck(:id)
  end
  
  #CSV読み込み
  def import
    if params[:file]
      User.import(params[:file])
      redirect_to current_user
    else
      redirect_to users_path
    end
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :depart, :employee_number, :uid, :basic_work_time,
                                   :designated_work_start_time, :designated_work_end_time) #adminを追加してもREDにならなかった。
                                   
    end
    
    # beforeフィルター
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    def search_params
      params.require(:q).permit(:name_cont)
    end
    
end
