class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
   private

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end
    
    def correct_but_admin_user
      if current_user.admin?
      else
        @user = User.find(params[:id])
        redirect_to(root_url) unless current_user?(@user)
      end
    end
    
    def correct_but_superior_user
      if current_user.superior 
      else
        @user = User.find(params[:id])
        redirect_to(root_url) unless current_user?(@user)
      end
    end
    
    # def ensure_correct_user
    #   item = Item.find(params[:id])
    #   if current_user.id != item.user_id
    #     flash[:danger] = "アクセス権限がありません"
    #     redirect_to items_path
    #   end
      
    # end
    
end
