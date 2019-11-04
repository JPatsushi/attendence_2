class AddStatusToTimeCards < ActiveRecord::Migration[5.1]
  def change
    add_column :time_cards, :status, :string
  end
end
