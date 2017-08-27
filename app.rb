require "sinatra"
require "net/http"
require "securerandom"
require "sinatra/activerecord"
require_relative "models"

enable :sessions

set :session_secret, ENV['SESSION_SECRET'] || SecureRandom.hex(64)

configure :production, :development do
	db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

	ActiveRecord::Base.establish_connection(
			:adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
			:host     => db.host,
			:username => db.user,
			:password => db.password,
			:database => db.path[1..-1],
			:encoding => 'utf8'
	)
end

require_relative "models"

$stdout.sync = true

get "/" do
  erb :index
end

get "/articles/new" do
  erb :newArticle
end

=begin

get "/" do
  erb :home
end

get "/logout" do
  session.clear
  redirect "/"
end

get "/seoauth" do
  scope = "" # "no-expiry"
  redirect "https://stackexchange.com/oauth?client_id=10559&scope=#{scope}&redirect_uri=#{request.base_url}/seoauth/return"
end

get "/seoauth/return" do
  a = Net::HTTP.post_form(URI("https://stackexchange.com/oauth/access_token/json"), client_id: ENV['SE_CLIENT_ID'], client_secret: ENV['SE_CLIENT_SECRET'], code: params[:code], redirect_uri: "#{request.base_url}/seoauth/return")
  token = JSON.parse(a.body)['access_token']
  user = api_get("me", token: token)
  if User.exists?(se_id: user['user_id'].to_i)
    b = User.find_by(se_id: user['user_id'].to_i)
    b.token = token
    b.save
  else
    b = User.create(token:token, session:SecureRandom.base64, se_id: user['user_id'].to_i)
  end
  session[:id] = b.session
  redirect "/"
end

def logged_in?
  return false unless User.exists?(session:session[:id])
  true
end

def api_get(url, site: "cseducators", token: false)
  uri = URI("https://api.stackexchange.com/#{url}")
  access_token = token || User.find_by(session:session[:id]).token
  uri.query = URI.encode_www_form(site: site, access_token: access_token, key: ENV['SE_KEY'])
  val = JSON.parse(Net::HTTP.get_response(uri).body)['items']
  return val.first if val.length == 1
  val
end

get "/info" do
  redirect back unless logged_in?
  user = api_get "me"
  @user = user
  erb :info
end

=end
