class LocationsController < ApplicationController
  
  def index
    @title = '拠点一覧'
    @location = Location.new
    @locations = Location.all
  end
  
  def update
    location = Location.find(params[:id])
    if location.update_attributes(location_params)
      flash[:info] = "拠点更新成功"
    else
      flash[:danger] = "拠点更新失敗"
    end
    
    redirect_to locations_path
  end
  
  def destroy
    location = Location.find(params[:id])
    name = location.lo_name
    location.destroy
    flash[:success] = "#{name}を削除しました"
    redirect_to locations_path
    
  end
  
  def create
    # byebug
    @location = Location.new(location_params)
    if @location.save
      flash[:info] = "拠点保存成功"
    else
      flash[:danger] = "拠点保存失敗"
    end
    
    redirect_to locations_path
  end
  
  
  private
  
    def location_params
      params.require(:location).permit(:lo_number, :lo_name, :lo_type)
    end
end
