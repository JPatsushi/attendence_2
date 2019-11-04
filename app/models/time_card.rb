class TimeCard < ApplicationRecord
  belongs_to :user

  validates :year, presence: true
  validates :month, presence: true
  validates :day, presence: true
  # validate :valid_date
  # validates :in_at, presence: true, if: lambda { |m| !m.out_at.nil? }
  # validate :out_at_is_later_than_in_at
  
  # attr_accessor :must_work_time, :sd_work_time

  class << self
    # 今日のタイムカードを取得する
    def today(user)
      date = Time.current
      condition = { user: user, year: date.year, month: date.month, day: date.day }
      TimeCard.find_by(condition) || self.new(condition)
    end
    
    def prev_day(user)
      date = Time.current.prev_day
      condition = { user: user, year: date.year, month: date.month, day: date.day }
      TimeCard.find_by(condition) || self.new(condition)
    end

    # 指定年月のタイムカードを取得する
    def monthly(user, year, month)
      TimeCard.where(user: user, year: year, month: month).order(:day).all
    end
  end

  # 勤務時間（秒）を返す
  def work_hours
    if in_at && out_at
      out_at - in_at
    else
      0
    end
  end
  
  private

end