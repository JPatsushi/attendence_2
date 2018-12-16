class MonthlyAuthenticationsController < ApplicationController
  
  #ユーザーが一ヶ月承認申請ボタンを押す後に実行
  def update
    
    today = Time.current
    @year = today.year
    @month = today.month
    @user = User.find(params[:id])
    
    
    if params[:superior_man].present?
      @monthly_authentication = @user.monthly_authentications.find_by(year: @year, month: @month)
      @superior = User.find(params[:superior_man])
      @monthly_authentication.update_attributes(certifier: params[:superior_man], status: "#{@superior.name}に申請中")
    else
      flash[:danger] = "承認者を指定してください"
    end
    
    
    redirect_to time_card_path(@user)
  end
  
  #上長が一ヶ月承認申請を変更する時に実行
  def monthly_update
    @monthly_authentications = MonthlyAuthentication.where(certifier: current_user.id)
      @monthly_authentications.each do |obj|
        if params[obj.user.id.to_s][obj.year.to_s] && params[obj.user.id.to_s][obj.year.to_s][obj.month.to_s] 
          if params[obj.user.id.to_s][obj.year.to_s][obj.month.to_s][:status] && params[obj.user.id.to_s][obj.year.to_s][obj.month.to_s][:check] == "1"        
            if params[obj.user.id.to_s][obj.year.to_s][obj.month.to_s][:status] == "承認" || params[obj.user.id.to_s][obj.year.to_s][obj.month.to_s][:status] == "否認"
              obj.status = "#{current_user.name}から" + params[obj.user.id.to_s][obj.year.to_s][obj.month.to_s][:status] + "済"
              obj.certifier = nil
              obj.save
            else
              obj.status = params[obj.user.id.to_s][obj.year.to_s][obj.month.to_s][:status]
              obj.certifier = nil
              obj.save
            end
          end
        end
      end
      redirect_to time_card_path(id: current_user.id)
  end
  
  private
  
    def monthly_authentication_params
      params.require(:monthly_authentication).permit(:superior, :year, :month, :status)
                                  
    end
end
