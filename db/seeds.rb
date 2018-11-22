# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)
             
User.create!(name:  "上長A",
             email: "jyouchou@railstutorial.org",
             password:              "foobar1",
             password_confirmation: "foobar1",
             depart:"フリーランス部",
             employee_number: 3333,
             basic_work_time: Time.zone.local(2018, 11, 20, 8, 0, 0),
             designated_work_start_time: Time.zone.local(2018, 11, 20, 6, 30, 0),
             designated_work_end_time: Time.zone.local(2018, 11, 20, 15, 30, 0),
             superior:     true,
             activated: true,
             activated_at: Time.zone.now)             
             
User.create!(name:  "上長B",
             email: "jyouchou-1@railstutorial.org",
             password:              "foobar2",
             password_confirmation: "foobar2",
             depart:"フリーランス部",
             employee_number: 4444,
             basic_work_time: Time.zone.local(2018, 11, 20, 8, 0, 0),
             designated_work_start_time: Time.zone.local(2018, 11, 20, 6, 30, 0),
             designated_work_end_time: Time.zone.local(2018, 11, 20, 15, 30, 0),
             superior:     true,
             activated: true,
             activated_at: Time.zone.now)             

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end

# 一ヶ月勤怠申請
user = User.find_by(id:4)
user.monthly_authentications.create!(year: 2018,
                                 month: 10,
                                 certifier: 2,
                                 status: "申請中"
                                 )
user.monthly_authentications.create!(year: 2018,
                                 month: 11,
                                 certifier: 2,
                                 status: "申請中"
                                 )                                
user_2 = User.find_by(id:3)
user_2.monthly_authentications.create!(year: 2018,
                                 month: 10,
                                 certifier: 2,
                                 status: "申請中"
                                 )
# 拠点一覧
Location.create!(lo_number: 1,
                 lo_name: "東京",
                 lo_type: "出勤"
                 )
Location.create!(lo_number: 2,
                 lo_name: "大阪",
                 lo_type: "退勤"
                 )
Location.create!(lo_number: 3,
                 lo_name: "山形",
                 lo_type: "なし"
                 ) 
# 残業申請
user.time_cards.create!(year:2018,
                        month:11,
                        day:20,
                        over_work: Time.zone.local(2018, 11, 20, 21, 30, 0),
                        content: "残業したいから",
                        certifer: 2,
                        status: "上長Aに残業申請中",
                        )
user.time_cards.create!(year:2018,
                        month:11,
                        day:21,
                        over_work: Time.zone.local(2018, 11, 21, 21, 30, 0),
                        content: "残業本当にしたいから",
                        certifer: 2,
                        status: "上長Aに残業申請中",
                        ) 
user_2.time_cards.create!(year:2018,
                         month:11,
                         day:20,
                         over_work: Time.zone.local(2018, 11, 20, 21, 30, 0),
                         content: "残業はしたくないがするしかないから",
                         certifer: 2,
                         status: "上長Aに残業申請中",
                         )                        
# 勤怠変更申請
user.time_cards.create!(year:2018,
                        month:11,
                        day:22,
                        in_at: Time.zone.local(2018, 11, 22, 8, 50, 0),
                        out_at: Time.zone.local(2018, 11, 22, 18, 30, 0),
                        tmp_in_at: Time.zone.local(2018, 11, 22, 7, 30, 0),
                        tmp_out_at: Time.zone.local(2018, 11, 22, 22, 50, 0),
                        remark: "ただ変更したいから",
                        change_certifier: 2,
                        status: "上長Aに勤怠変更申請中",
                        )
user.time_cards.create!(year:2018,
                        month:11,
                        day:23,
                        in_at: Time.zone.local(2018, 11, 23, 8, 32, 0),
                        out_at: Time.zone.local(2018, 11, 23, 18, 45, 0),
                        tmp_in_at: Time.zone.local(2018, 11, 23, 7, 0, 0),
                        tmp_out_at: Time.zone.local(2018, 11, 23, 22, 0, 0),
                        remark: "ただ変更したいからだよ",
                        change_certifier: 2,
                        status: "上長Aに勤怠変更申請中",
                        ) 
user_2.time_cards.create!(year:2018,
                        month:11,
                        day:22,
                        in_at: Time.zone.local(2018, 11, 22, 8, 50, 0),
                        out_at: Time.zone.local(2018, 11, 22, 18, 30, 0),
                        tmp_in_at: Time.zone.local(2018, 11, 22, 7, 30, 0),
                        tmp_out_at: Time.zone.local(2018, 11, 22, 22, 50, 0),
                        remark: "ただ変更したいからだべ",
                        change_certifier: 2,
                        status: "上長Aに勤怠変更申請中",
                        )                        

