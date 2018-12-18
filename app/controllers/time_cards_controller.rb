class TimeCardsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_but_admin_user, only: [:show]
  before_action :admin_user, only: [:new, :create]
    
  
  def show
    @user = User.find(params[:id])
  
    if session[:month] 
      @year = session[:year]
      @month = session[:month]
    else
      today = Time.current
      @year = today.year
      @month = today.month
    end
    
    @time_cards = monthly_time_cards(@user, @year, @month)
    @time_card = TimeCard.today(@user)
    
    @first_day = Date.new(@year, @month, 1)
    @last_day = Date.new(@year, @month, 1).next_month.prev_day
    
    @time_info = TimeInfo.all.last
    @time_cards_count = all_time_cards_for_count(@user)
    @user_time_cards = TimeCard.where(user: @user)
    store(@year,@month)
  end
  
  def updata
    @user = User.find(params[:id])
    @time_card = TimeCard.today(@user)
    ajax_show_action
    # render 'show'
    redirect_to time_card_path(@user)
  end
  
  def new
    @time_info = TimeInfo.new
  end
  
  def create
    
    # これは使えない @time_info = TimeInfo.new(must_work_time: params[:must_work_time], sd_work_time: params[:sd_work_time])
     @time_info = TimeInfo.new(time_info_params)
    if @time_info.save
      redirect_to current_user
    end

  end
  
  def edit
    @user = User.find(params[:id])
    @year = session[:year]
    @month = session[:month]
    @time_cards = monthly_time_cards(@user, @year, @month)
  end
  
  def update
    @user = User.find(params[:id])
    @year = session[:year]
    @month = session[:month]
    number_of_days_in_month = Date.new(@year, @month, 1).next_month.prev_day.day
    # @time_cards = monthly_time_cards(@user, @year, @month)
    (1..number_of_days_in_month).each do |number|
     s = (number - 1).to_s

      condition = { user: @user, year: @year, month: @month, day: number }
      if time_card = TimeCard.find_by(condition)
        # time_card.update_attributes(time_cards_params)
        time_card.in_at = params[:time_cards][s][:in_at] if !params[:time_cards][s][:in_at].empty?
        time_card.out_at = params[:time_cards][s][:out_at] if !params[:time_cards][s][:out_at].empty?
        time_card.remark = params[:time_cards][s][:remark] if !params[:time_cards][s][:remark].empty?
        time_card.save
       
      else
        time_card = TimeCard.new(condition)
        time_card.in_at = params[:time_cards][s][:in_at] if !params[:time_cards][s][:in_at].empty?
        time_card.out_at = params[:time_cards][s][:out_at] if !params[:time_cards][s][:out_at].empty?
        time_card.remark = params[:time_cards][s][:remark] if !params[:time_cards][s][:remark].empty?
        time_card.save
      end
        
       
    end
       
     
       redirect_to @user

  end
  
  
  
  def add
    @user = User.find(params[:id])
    @year = session[:year]
    @month = session[:month] + 1
    if @month == 13
      @year = @year + 1
      @month = 1
    end
    store(@year,@month)
    redirect_to time_card_path(@user)
  end
  
  def subtract
    @user = User.find(params[:id])
    @year = session[:year]
    @month = session[:month] - 1
    if @month == 0
      @year = @year - 1
      @month = 12
    end
    store(@year,@month)
    redirect_to time_card_path(@user)
  end
  
  def store(year,month)
      session[:year] = year
      session[:month] = month
  end
  

  private
  
    def time_cards_params
      params.require(:time_cards).permit(:in_at, :out_at)
                                  
    end

    # 指定年月の全ての日のタイムカードの配列を取得する（タイムカードが存在しない日はnil）
    def monthly_time_cards(user, year, month)
      number_of_days_in_month = Date.new(year, month, 1).next_month.prev_day.day
      results = Array.new(number_of_days_in_month) # 月の日数分nilで埋めた配列を用意
      time_cards = TimeCard.monthly(user, year, month)
      time_cards.each do |card|
        results[card.day - 1] = card
      end
      results
    end
    
    def all_time_cards_for_count(user)
      time_cards = TimeCard.where(user: user)
      count = 0
      time_cards.each do |card|
        if card.in_at && card.out_at
          count = count + 1
        end
      end
      count
    end

    # Ajaxでshowアクションが呼ばれた場合のハンドラ
    def ajax_show_action
      if params[:in]
        @time_card.in_at = Time.now
      elsif params[:out]
        @time_card.out_at = Time.now
      end
      
      @time_card.save

      # if @time_card.save
      #   render json: { status: 'success', time_card: @time_card, working_status: @time_card.working_status }
      # else
      #   render json: { status: 'error' }
      # end
    end 
    
    def time_info_params
      params.require(:time_info).permit(:must_work_time,:sd_work_time) 
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
