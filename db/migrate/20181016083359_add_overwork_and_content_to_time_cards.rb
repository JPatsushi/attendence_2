class AddOverworkAndContentToTimeCards < ActiveRecord::Migration[5.1]
  def change
    add_column :time_cards, :over_work, :datetime 
    add_column :time_cards, :content, :string
    add_column :time_cards, :certifer, :integer
  end
end
