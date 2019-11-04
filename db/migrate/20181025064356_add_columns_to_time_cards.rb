class AddColumnsToTimeCards < ActiveRecord::Migration[5.1]
  def change
    add_column :time_cards, :change_certifier, :integer
    add_column :time_cards, :tmp_in_at, :datetime
    add_column :time_cards, :tmp_out_at, :datetime
  end
end
