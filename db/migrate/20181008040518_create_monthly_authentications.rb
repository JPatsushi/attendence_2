class CreateMonthlyAuthentications < ActiveRecord::Migration[5.1]
  def change
    create_table :monthly_authentications do |t|
      
      t.string :year
      t.string :month
      t.integer :certifier
      t.integer :user_id
      t.string :content
      t.string :status, default: "未"

      t.timestamps
    end
  end
end
