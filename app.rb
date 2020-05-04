# ---------- gem関係 ---------- #

require 'rubygems'
require 'bundler'

Bundler.require

set :database, {adapter: "sqlite3", database: "scheduler.sqlite3"}

enable :sessions


# ---------- validation関係 ---------- #

class Schedule < ActiveRecord::Base
    validates_presence_of :from
    validates_presence_of :until
    validates_presence_of :todo
end


# ---------- ① index.erbの始まり ---------- #

get '/' do
    today = Date.current
    @this_week = [today.days_ago(3), today.days_ago(2), today.days_ago(1), today, today.days_since(1), today.days_since(2), today.days_since(3)]

    array = []
    @this_week.each do |t|
        val1 = t
        val2 = t.wday
        array << [val1, val2]
    end

    @monday = array.find{|arr| arr[1] == 1 }[0]
    @tuesday = array.find{|arr| arr[1] == 2 }[0]
    @wednesday = array.find{|arr| arr[1] == 3 }[0]
    @thursday = array.find{|arr| arr[1] == 4 }[0]
    @friday = array.find{|arr| arr[1] == 5 }[0]
    @saturday = array.find{|arr| arr[1] == 6 }[0]
    @sunday = array.find{|arr| arr[1] == 0 }[0]

    erb :index
end

# ---------- ② 全てのスケジュールを表示する画面に移行する ---------- #
# ---------- all.erbを呼び出す ---------- #

get '/list_all' do
    @schedules = Schedule.all
    @weeks = ["月","火","水","木","金","土","日"]
    erb :all
end


# ---------- ③ 特定の日付のスケジュール画面に移行する ---------- #
# ---------- scheduler_form.erbを呼び出す ---------- #

get '/scheduler_form/:specific_day' do
    @specific_day = params[:specific_day]
    @schedules = Schedule.where(date: params[:specific_day] ).order(from: :asc)
    @weeks = ["月","火","水","木","金","土","日"]
    erb :scheduler_form
end


# ---------- ④ スケジュールの入力処理 ---------- #
# ---------- 入力処理後、特定の日付のスケジュール画面（③）に戻る ---------- #

post '/scheduler_form' do
    schedule = Schedule.new({date: params[:date], from: params[:from], until: params[:until], todo: params[:todo], category: params[:category], memo: params[:memo]})
    schedule.save
    redirect "/scheduler_form/#{params[:date]}"
end


# ---------- ⑤ スケジュールの修正画面に移行する ---------- #
# ---------- edit.erbを呼び出す ---------- #

get '/edit/:specific_day/:specific_id' do
    @schedules = Schedule.where(id: params[:specific_id])
    @edit = Schedule.find(params[:specific_id])
    @weeks = ["月","火","水","木","金","土","日"]
    erb :edit
end


# ---------- ⑥ スケジュールの修正処理 ---------- #
# ---------- 修正処理後、特定の日付のスケジュール画面（③）に戻る ---------- #

post '/editing' do
    @edit = Schedule.find(params[:editing_id])
    @edit.update(date: params[:date], from: params[:from], until: params[:until], todo: params[:todo], category: params[:category], memo: params[:memo])
    @edit.save
    @time_until = params[:until]
    redirect "/scheduler_form/#{params[:date]}"  
end

# ---------- ⑦ スケジュールの消去処理 ---------- #
# ---------- 修正処理後、特定の日付のスケジュール画面（③）に戻る ---------- #

get '/delete/:specific_day/:id' do
    @delete = Schedule.find(params[:id])
    @delete.destroy
    redirect "/scheduler_form/#{params[:specific_day]}"  
end






# get '/' do
#     @now = Time.now
#     @contacts = Contact.all
#     @message = session.delete :message
#     erb :index
# end

# get '/contact_new' do
#     @contact = Contact.new
#     erb :contact_form
# end

# post '/contacts' do
#     puts "### 送信されたデータ ###"
#     p params
    
#     name = params[:name]
    
#     # DBに保存
#     @contact = Contact.new({name: name, email: params[:email]})
#     if @contact.save
#         # true
#         session[:message] = "#{name}さんを作成しました"
#         redirect '/'
#     else
#         # false
#         erb :contact_form
#     end
# end
