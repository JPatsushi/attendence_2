require 'csv'

CSV.generate do |csv|
  column_names = %w(year month day in_time out_time remark)
  csv << column_names
  @time_cards.each do |time_card|
    if time_card
  
      column_values = [
          time_card.year,
          time_card.month,
          time_card.day,
          time_card.in_at,
          time_card.out_at,
          time_card.remark,
       ]
     
    end
     
    if column_values
      csv << column_values
    end
    
  end
end